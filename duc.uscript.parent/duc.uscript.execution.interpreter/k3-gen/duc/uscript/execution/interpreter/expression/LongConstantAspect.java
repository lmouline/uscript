package duc.uscript.execution.interpreter.expression;

import duc.uscript.execution.ExecutionFactory;
import duc.uscript.execution.LongValue;
import duc.uscript.execution.State;
import duc.uscript.execution.Value;
import duc.uscript.execution.interpreter.expression.ExpressionAspect;
import duc.uscript.execution.interpreter.expression.LongConstantAspectLongConstantAspectProperties;
import duc.uscript.uScript.LongConstant;
import fr.inria.diverse.k3.al.annotationprocessor.Aspect;
import fr.inria.diverse.k3.al.annotationprocessor.OverrideAspectMethod;
import org.eclipse.xtext.xbase.lib.ObjectExtensions;
import org.eclipse.xtext.xbase.lib.Procedures.Procedure1;

@Aspect(className = LongConstant.class)
@SuppressWarnings("all")
public class LongConstantAspect extends ExpressionAspect {
  @OverrideAspectMethod
  public static Value evaluateExpression(final LongConstant _self, final State state) {
    final duc.uscript.execution.interpreter.expression.LongConstantAspectLongConstantAspectProperties _self_ = duc.uscript.execution.interpreter.expression.LongConstantAspectLongConstantAspectContext.getSelf(_self);
    Object result = null;
    // #DispatchPointCut_before# Value evaluateExpression(State)
    if (_self instanceof duc.uscript.uScript.LongConstant){
    	result = duc.uscript.execution.interpreter.expression.LongConstantAspect._privk3_evaluateExpression(_self_, (duc.uscript.uScript.LongConstant)_self,state);
    };
    return (duc.uscript.execution.Value)result;
  }
  
  private static Value super_evaluateExpression(final LongConstant _self, final State state) {
    final duc.uscript.execution.interpreter.expression.ExpressionAspectExpressionAspectProperties _self_ = duc.uscript.execution.interpreter.expression.ExpressionAspectExpressionAspectContext.getSelf(_self);
    return  duc.uscript.execution.interpreter.expression.ExpressionAspect._privk3_evaluateExpression(_self_, _self,state);
  }
  
  protected static Value _privk3_evaluateExpression(final LongConstantAspectLongConstantAspectProperties _self_, final LongConstant _self, final State state) {
    LongValue _createLongValue = ExecutionFactory.eINSTANCE.createLongValue();
    final Procedure1<LongValue> _function = (LongValue it) -> {
      String _value = _self.getValue();
      int _length = _self.getValue().length();
      int _minus = (_length - 1);
      final String strValue = _value.substring(0, _minus);
      it.setValue(Long.parseLong(strValue));
    };
    return ObjectExtensions.<LongValue>operator_doubleArrow(_createLongValue, _function);
  }
}
