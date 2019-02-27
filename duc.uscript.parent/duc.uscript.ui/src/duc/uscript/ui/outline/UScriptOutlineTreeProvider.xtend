/*
 * generated by Xtext 2.16.0
 */
package duc.uscript.ui.outline

import org.eclipse.xtext.ui.editor.outline.impl.DefaultOutlineTreeProvider
import duc.uscript.uScript.Field
import org.eclipse.xtext.ui.editor.outline.impl.DocumentRootNode
import duc.uscript.uScript.Script
import duc.uscript.uScript.Parameter
import static duc.uscript.typing.TypeNameHelper.*
import duc.uscript.uScript.Method
import duc.uscript.uScript.Block
import org.eclipse.xtext.ui.editor.outline.IOutlineNode
import duc.uscript.uScript.TypeRef

/**
 * Customization of the default outline structure.
 *
 * See https://www.eclipse.org/Xtext/documentation/310_eclipse_support.html#outline
 */
class UScriptOutlineTreeProvider extends DefaultOutlineTreeProvider {
	
	// Tree customization
	def _isLeaf(Field d) {
		return true;
	}
	
	def _createChildren(DocumentRootNode outlineNode, Script script) {
		script.elements.forEach[ elm |
			createNode(outlineNode, elm)
		]
	}
		
	// Label customization
	def _text(Field f) {
		return '''«f.name»: «getSyntax(f.typeRef)»'''
	}
	
	def _text(Method c) {
		var text = c.name + "("
		for(var i=0; i<c.params.length; i++) {
			text+= c.params.get(i).name + ": " + getSyntax(c.params.get(i).typeRef)
			
			if(i != c.params.length - 1) {
				text+=", "
			}
		}
		text += ")"
		return text
	}

}
