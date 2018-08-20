/*
 * generated by Xtext 2.14.0
 */
package duc.uminijava.validation

import org.eclipse.xtext.validation.Check
import duc.uminijava.uMiniJava.BernoulliRef
import duc.uminijava.uMiniJava.UMiniJavaPackage

import duc.uminijava.typing.UMiniJavaTypeComputer
import duc.uminijava.uMiniJava.NewUObject
import com.google.inject.Inject
import org.tetrabox.minijava.xtext.miniJava.Expression
import duc.uminijava.typing.UMiniJavaTypeConformance
import org.tetrabox.minijava.xtext.miniJava.Or
import org.eclipse.emf.ecore.EReference
import org.tetrabox.minijava.xtext.miniJava.MiniJavaPackage
import org.tetrabox.minijava.xtext.miniJava.And
import org.tetrabox.minijava.xtext.miniJava.Not
import org.tetrabox.minijava.xtext.miniJava.ArrayAccess
import org.tetrabox.minijava.xtext.miniJava.TypeDeclaration
import duc.uminijava.uMiniJava.GaussianRef
import org.tetrabox.minijava.xtext.miniJava.DoubleConstant
import org.tetrabox.minijava.xtext.miniJava.BooleanTypeRef
import org.tetrabox.minijava.xtext.miniJava.TypedDeclaration
import duc.uminijava.uMiniJava.ExistExpr

/**
 * This class contains custom validation rules. 
 *
 * See https://www.eclipse.org/Xtext/documentation/303_runtime_concepts.html#validation
 */
class UMiniJavaValidator extends AbstractUMiniJavaValidator {
	
	@Inject 
	extension UMiniJavaTypeComputer
	
	@Inject
	extension UMiniJavaTypeConformance
	
	@Check
	def checkNewUType(NewUObject objCreation) {
		if(objCreation.type instanceof BernoulliRef) {
			checkBernoulliRef(objCreation.type as BernoulliRef, UMiniJavaPackage.eINSTANCE.newUObject_Type)
			
			if(objCreation.args.length != 2) {
				error("Creation of Bernoulli required two arguments.", UMiniJavaPackage.eINSTANCE.newUObject_Args)
				return
			}
			
			if(objCreation.args.get(0).typeFor !== UMiniJavaTypeComputer.BOOLEAN_TYPE) {
				error('''First argument should be a boolean expression. Actual: «objCreation.args.get(0).typeFor.name»''', UMiniJavaPackage.eINSTANCE.newUObject_Args,0)
			} 
			
			if(!objCreation.args.get(1).typeFor.isConformant(UMiniJavaTypeComputer.DOUBLE_TYPE)) {
				error('''Second argument should be a float or double expression. Actual: «objCreation.args.get(1).typeFor.name»''', UMiniJavaPackage.eINSTANCE.newUObject_Args, 1)
			}
			
			if(objCreation.args.get(1) instanceof DoubleConstant) {
				val doubleVal = (objCreation.args.get(1) as DoubleConstant).value
				if(doubleVal < 0 || doubleVal > 1) {
					warning("Confidence value should be in [0;1] range.", UMiniJavaPackage.eINSTANCE.newUObject_Args, 1)
				}
			}
		} else if(objCreation.type instanceof GaussianRef) {
			checkGaussianRef(objCreation.type as GaussianRef, MiniJavaPackage.eINSTANCE.typedDeclaration_TypeRef)
			
			if(objCreation.args.length != 1 && objCreation.args.length != 2) {
				error("Creation of Gaussian required one or two arguments.", UMiniJavaPackage.eINSTANCE.newUObject_Args)
				return
			}
			
			if(objCreation.args.length == 1) {
				if(!objCreation.args.get(0).typeFor.isConformant(UMiniJavaTypeComputer.DOUBLE_TYPE)) {
					error('''Argument should be a double type. Actual: «objCreation.args.get(0).typeFor.name»''', UMiniJavaPackage.eINSTANCE.newUObject_Args,0)
				}
			} else {
				val genericType = objCreation.type.genericType.type
				if(!objCreation.args.get(0).typeFor.isConformant(genericType)) {
					error('''Argument type should be compatible with «genericType.name». Actual: «objCreation.args.get(0).typeFor.name»''', UMiniJavaPackage.eINSTANCE.newUObject_Args,0)
				}
				if(!objCreation.args.get(1).typeFor.isConformant(UMiniJavaTypeComputer.DOUBLE_TYPE)) {
					error('''Argument should be a double type. Actual: «objCreation.args.get(1).typeFor.name»''', UMiniJavaPackage.eINSTANCE.newUObject_Args,0)
				}
			}
						
		}
	}
		
	def checkBernoulliRef(BernoulliRef ref, EReference eRef) {
		if(!(ref.genericType instanceof BooleanTypeRef)) {
			error('''Currently, only boolean type is supported for Bernoulli. Actual: «ref.genericType.type»''', eRef)
		}
	}
	
	def checkGaussianRef(GaussianRef ref, EReference eRef) {
		if(!(ref.genericType.type.isConformant(UMiniJavaTypeComputer.LONG_TYPE) || ref.genericType.type.isConformant(UMiniJavaTypeComputer.DOUBLE_TYPE))) {
			error('''Currently, only numerical types are supported by Gaussian. Actual: «ref.genericType.type»''', eRef)
		}
	}
	

	
	@Check override void checkConformance(Expression exp) {
		val actualType = exp.typeFor
		val expectedType = exp.expectedType
						
		if (expectedType === null || actualType === null)
			return; // nothing to check
		if (!actualType.isConformant(expectedType)) {
			error("Incompatible types. Expected '" + expectedType.name + "' but was '" + actualType.name + "'", null,
				INCOMPATIBLE_TYPES);
		}
	}

	@Check
	override dispatch checkType(Or or) {
		checkBooleanOrUBoolen(or.left, MiniJavaPackage.eINSTANCE.or_Left)
		checkBooleanOrUBoolen(or.right, MiniJavaPackage.eINSTANCE.or_Right)
	}
	
	
	@Check
	def checkFunctionType(TypedDeclaration typedDcl) {
		if(typedDcl.typeRef instanceof BernoulliRef) {
			checkBernoulliRef(typedDcl.typeRef as BernoulliRef, MiniJavaPackage.eINSTANCE.typedDeclaration_TypeRef)
			return
		} 
		
		if(typedDcl.typeRef instanceof GaussianRef) {
			checkGaussianRef(typedDcl.typeRef as GaussianRef, MiniJavaPackage.eINSTANCE.typedDeclaration_TypeRef)
			return
		}
	}
	
	@Check
	override dispatch checkType(And and) {
		checkBooleanOrUBoolen(and.left, MiniJavaPackage.eINSTANCE.and_Left)
		checkBooleanOrUBoolen(and.right, MiniJavaPackage.eINSTANCE.and_Right)
	}
	
	@Check
	override dispatch checkType(Not not) {
		checkBooleanOrUBoolen(not.expression, MiniJavaPackage.eINSTANCE.and_Left)
	}
	
	def private checkBooleanOrUBoolen(Expression exp, EReference ref) {
		if(exp.typeFor !== UMiniJavaTypeComputer.BOOLEAN_TYPE && exp.typeFor !== UMiniJavaTypeComputer.BERNOULLI_TYPE) {
			error('''Should be boolean or Bernoulli. Actual: «exp.typeFor.name»''', ref, INCOMPATIBLE_TYPES)
		}
	}
	
	@Check
	override dispatch checkType(ArrayAccess arrayAccess) {
		val TypeDeclaration objectType = arrayAccess.object.typeFor
		if(!objectType.isArray && objectType !== UMiniJavaTypeComputer.BERNOULLI_TYPE) {
			error('''Should be an array or a Bernoulli type. Actual type: «objectType.name»''', MiniJavaPackage.eINSTANCE.arrayAccess_Object, INCOMPATIBLE_TYPES)
		}
		
		if(objectType.isArray && !arrayAccess.index.typeFor.isConformant(UMiniJavaTypeComputer.INT_TYPE)) {
			error('''Should be an int expression. Actual type: «arrayAccess.index.typeFor.name»''', MiniJavaPackage.eINSTANCE.arrayAccess_Index)
		}
		
		if(objectType === UMiniJavaTypeComputer.BERNOULLI_TYPE && !arrayAccess.index.typeFor.isConformant(UMiniJavaTypeComputer.DOUBLE_TYPE)) {
			error('''Should be an int or a double expression. Actual type: «arrayAccess.index.typeFor.name»''', MiniJavaPackage.eINSTANCE.arrayAccess_Index)
		}
		
	}
	
	@Check 
	def dispatch checkType(ExistExpr existExp) {
		if(!existExp.expr.typeFor.isUncertainType) {
			error('''Should have an uncertain type. Actual: «existExp.typeFor.name»''', UMiniJavaPackage.eINSTANCE.existExpr_Expr)
		}
		
		if(!existExp.confidence.typeFor.isConformant(UMiniJavaTypeComputer.DOUBLE_TYPE)) {
			error('''Should have a double type. Actual: «existExp.typeFor.name»''', UMiniJavaPackage.eINSTANCE.existExpr_Confidence)
		}
		
	}
	
	override protected checkNumber(Expression exp, EReference ref) {
		if(!(exp.typeFor.isNumber || exp.typeFor.isConformant(UMiniJavaTypeComputer.GAUSSIAN_TYPE))) {
			error('''Should be a numeric expression. Actual type: «exp.typeFor.name»''', ref, INCOMPATIBLE_TYPES)
		}
	}
		
	
	
	
	
}
