import RactiveValueWidget from "./value-widget.js"
import EditForm from "./edit-form.js"
import RactiveEditFormVariable from "./subcomponent/variable.js"

SwitchEditForm = EditForm.extend({

  data: -> {
    display: undefined # String
  }

  twoway: false

  components: {
    formVariable: RactiveEditFormVariable
  }

  genProps: (form) ->
    variable = form.variable.value
    {
       display: variable
    , variable: variable.toLowerCase()
    }

  partials: {

    title: "Switch"

    widgetFields:
      """
      <formVariable id="{{id}}-varname" name="variable" value="{{display}}"/>
      """

  }

})

RactiveSwitch = RactiveValueWidget.extend({

  data: -> {
    contextMenuOptions: [@standardOptions(this).edit, @standardOptions(this).delete]
  , resizeDirs:         ['left', 'right']
  }

  widgetType: "switch"

  # `on` and `currentValue` should be synonymous for Switches.  It is necessary that we
  # update `on`, because that's what the widget reader looks at at compilation time in
  # order to determine the value of the Switch. --Jason B. (3/31/16)
  observe: {
    'widget.on': (isOn, wasOn) ->
      if (isOn isnt wasOn)
        @set('internalValue', isOn)
        @fire('widget-value-change')
      return

    'widget.currentValue': (isOn) ->
      @set('widget.on', isOn)
      return
  }

  components: {
    editForm: SwitchEditForm
  }

  eventTriggers: ->
    { variable: [@_weg.recompile, @_weg.rename] }

  minWidth:  35
  minHeight: 33

  template:
    """
    {{>editorOverlay}}
    {{>switch}}
    <editForm idBasis="{{id}}" display="{{widget.display}}" />
    """

  # coffeelint: disable=max_line_length
  partials: {

    switch:
      """
      <label id="{{id}}" class="netlogo-widget netlogo-switcher netlogo-input {{classes}}" style="{{dims}}">
        <input type="checkbox" checked="{{ internalValue }}" on-change="widget-value-change" {{# isEditing }} disabled{{/}} />
        <span class="netlogo-label">{{ widget.display }}</span>
      </label>
      """

  }
  # coffeelint: enable=max_line_length

})

export default RactiveSwitch
