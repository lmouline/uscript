package duc.uscript.execution.interpreter.expression.constants

import fr.inria.diverse.k3.al.annotationprocessor.Aspect
import fr.inria.diverse.k3.al.annotationprocessor.OverrideAspectMethod
import duc.uscript.uScript.IntConstant
import duc.uscript.execution.Value
import duc.uscript.execution.State
import duc.uscript.execution.ExecutionFactory
import duc.uscript.execution.interpreter.expression.ExpressionAspect
import duc.uscript.utils.SymbolSet

@Aspect(className=IntConstant)
class IntConstantAspect extends ExpressionAspect {
	@OverrideAspectMethod
	def Value evaluateExpression(State state) {
		return ExecutionFactory::eINSTANCE.createIntegerValue => [
			value = _self.value
		]
	}
	
	@OverrideAspectMethod
	def SymbolSet findDependentVariables(State state) {
		return new SymbolSet
	}
}
