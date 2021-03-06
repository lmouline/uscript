package duc.uscript.execution.interpreter.expression

import fr.inria.diverse.k3.al.annotationprocessor.Aspect
import duc.uscript.uScript.NewUObject
import fr.inria.diverse.k3.al.annotationprocessor.OverrideAspectMethod
import duc.uscript.execution.Value
import duc.uscript.execution.State
import duc.uscript.uScript.GaussianRef
import duc.uscript.uScript.RayleighRef
import duc.uscript.uScript.BinomialRef
import duc.uscript.uScript.DiracRef
import duc.uscript.execution.ExecutionFactory
import duc.uscript.uScript.Field
import duc.uscript.typing.InternalTypeDcl
import com.google.inject.Injector
import duc.uscript.UScriptStandaloneSetupGenerated
import static extension duc.uscript.execution.interpreter.modelstate.ValueAspect.*
import duc.uscript.typing.TypeResolver
import duc.uscript.uScript.BernoulliRef
import duc.uscript.execution.BooleanValue
import duc.uscript.execution.DoubleValue
import static duc.uscript.execution.interpreter.utils.BernoulliBoolUtils.createBernoulliBool
import duc.uscript.utils.SymbolSet
import duc.uscript.uScript.Expression
import duc.uscript.utils.Range
import duc.uscript.utils.RangeFactory
import duc.uscript.uScript.PoissonBinomialRef
import duc.uscript.uScript.MultPossibilitiesRef

@Aspect(className=NewUObject)
class NewUObjectAspect extends ExpressionAspect{
	
	@OverrideAspectMethod
	def Value evaluateExpression(State state) {
		val Injector injector = new UScriptStandaloneSetupGenerated().createInjectorAndDoEMFRegistration()
		
		val internalTypeDcl = injector.getInstance(InternalTypeDcl)
		val typeResolver = injector.getInstance(TypeResolver)
				
		return switch (_self.type) {
			GaussianRef: createDistNumeric(_self, state, internalTypeDcl, typeResolver)
			RayleighRef: createDistNumeric(_self, state, internalTypeDcl, typeResolver)
			BinomialRef: createDistNumeric(_self, state, internalTypeDcl, typeResolver)
			DiracRef: createDistNumeric(_self, state, internalTypeDcl, typeResolver)
			BernoulliRef: createDistBool(_self, state, internalTypeDcl, typeResolver)
			PoissonBinomialRef: createPoissBin(_self, state, internalTypeDcl, typeResolver)
			MultPossibilitiesRef: createMultChoices(_self, state, internalTypeDcl, typeResolver)
			default: throw new RuntimeException("Not yet implemented for " + _self.type.class.name)
		}
	}
	
	private def static Value createDistNumeric(State state, InternalTypeDcl typeDcl, TypeResolver typeResolver) {
		val mean = _self.args.get(0).evaluateExpression(state)
		val variance = _self.args.get(1).evaluateExpression(state)
				
		val dist = ExecutionFactory::eINSTANCE.createObjectInstance => [
			type = typeDcl.getDistType(_self.type)
		]
		dist.fieldbindings.add(ExecutionFactory::eINSTANCE.createFieldBinding => [
			field = dist.type.members.filter(Field).get(0)
			value = mean
		])
		dist.fieldbindings.add(ExecutionFactory::eINSTANCE.createFieldBinding => [
			field = dist.type.members.filter(Field).get(1)
			value = variance
		])
		state.objectsHeap.add(dist)
		
		val refDist = ExecutionFactory::eINSTANCE.createObjectRefValue => [
			instance = dist
		]
		
		val finalType = typeResolver.type(_self.type)
		val result = ExecutionFactory::eINSTANCE.createObjectInstance => [
			type = finalType
		]
		
		result.fieldbindings.add(ExecutionFactory::eINSTANCE.createFieldBinding => [
			field = typeDcl.getUType(_self.type).members.filter(Field).get(0)
			value = refDist
		])
		result.fieldbindings.add(ExecutionFactory::eINSTANCE.createFieldBinding => [
			field = finalType.members.filter(Field).get(0)
			value = mean.copy
		])
		state.objectsHeap.add(result)
		
		return ExecutionFactory::eINSTANCE.createObjectRefValue => [instance = result]
	}
		
	private def static Value createDistBool(State state, InternalTypeDcl typeDcl, TypeResolver typeResolver) {
		val uValue = _self.args.get(0).evaluateExpression(state) as BooleanValue
		val probability = _self.args.get(1).evaluateExpression(state) as DoubleValue
		
		if(!uValue.value) {
			probability.value = 1 - probability.value
		}
				
		val result = createBernoulliBool(state, probability.value, uValue.value, _self)
		
		return ExecutionFactory::eINSTANCE.createObjectRefValue => [instance = result]
	}
	
	private def static Value createMultChoices(State state, InternalTypeDcl typeDcl, TypeResolver typeResolver) {
		val res = ExecutionFactory::eINSTANCE.createObjectInstance => [
			type= typeResolver.type(_self.type)
		]
		state.objectsHeap.add(res)

		return ExecutionFactory::eINSTANCE.createObjectRefValue => [instance = res]	
	}

	private def static Value createPoissBin(State state, InternalTypeDcl typeDcl, TypeResolver typeResolver) {
		
		val distInsc = ExecutionFactory::eINSTANCE.createObjectInstance => [
			type = typeDcl.getUType(_self.type)
		]
		state.objectsHeap.add(distInsc)
		val distRef = ExecutionFactory::eINSTANCE.createObjectRefValue => [ instance = distInsc]
		
		// PoissonBinomialInt object
		val finalType = typeResolver.type(_self.type)
		val result = ExecutionFactory::eINSTANCE.createObjectInstance => [
			type = finalType
		]
		state.objectsHeap.add(result)
		result.fieldbindings.add(ExecutionFactory::eINSTANCE.createFieldBinding =>[
			field= typeDcl.getPoissBinClass(_self).members.filter(Field).findFirst[it.name == "confidence"]
			value=distRef
		])
		
		return ExecutionFactory::eINSTANCE.createObjectRefValue => [instance = result]
	}
	
	@OverrideAspectMethod
	def SymbolSet findDependentVariables(State state) {
		val result = new SymbolSet
		
		for(Expression arg: _self.args) {
			result.addAll(findDependentVariables(arg, state))
		}
		
		return result
	}
	
	@OverrideAspectMethod
	def Range findRange(State state) {
		if(_self.args.size > 0) {
			return _self.args.get(0).findRange(state)
		} else {
			return RangeFactory.createFullRange()
		}
	}
}