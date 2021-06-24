import RactiveBlockForm from "./block-form.js"
import RactiveBuilder from "./builder.js"
import RactiveConfirmDialog from "./confirm-dialog.js"
import RactiveNetLogoModel from "./netlogo-model.js"
import RactivePopupMenu from "./popup-menu.js"

# (HTMLElement, Environment, Boolean, Boolean, (Boolean) => Unit) => Ractive
create = (element, playMode, runtimeMode, isDebugMode, setDebugMode) ->
  new Ractive({

    el: element,

    data: () -> {
      breeds:       []          # Array[String]
      canRedo:      false       # Boolean
      canUndo:      false       # Boolean
      isDebugMode:  isDebugMode # Boolean
      isSideBySide: false       # Boolean
      playMode:     playMode    # Boolean
      popupMenu:    undefined   # RactivePopupMenu
      runtimeMode:  runtimeMode # String
    }

    observe: {

      'isDebugMode': () ->
        setDebugMode(@get('isDebugMode'))
        return

    }

    on: {

      'complete': (_) ->
        popupMenu = @findComponent('popupMenu')
        @set('popupMenu', popupMenu)

        document.addEventListener('click', (event) ->
          if event?.button isnt 2
            popupMenu.unpop()
        )

        return

      '*.show-confirm-dialog': ({ event: { pageX, pageY } }, options) ->
        confirmDialog = @findComponent('confirmDialog')
        confirmDialog.show(options, Math.max(pageX - 200, 0), Math.max(pageY - 150, 0))
        return

      # (Context, Ractive, String, NetTangoBlock, Integer, String, String, String) => Unit
      '*.show-block-edit-form': (_, target, spaceName, block, blockIndex, submitLabel, submitEvent, cancelLabel) ->
        form = @findComponent('blockEditForm')
        form.show(target, spaceName, block, blockIndex, submitLabel, submitEvent, cancelLabel)
        overlay = @root.find('.widget-edit-form-overlay')
        overlay.classList.add('ntb-dialog-overlay')
        return

    }

    components: {
      blockEditForm: RactiveBlockForm
    , confirmDialog: RactiveConfirmDialog
    , netLogoModel:  RactiveNetLogoModel
    , popupMenu:     RactivePopupMenu
    , tangoBuilder:  RactiveBuilder
    },

    template:
      """
      <div class="ntb-components{{# isSideBySide }} netlogo-display-horizontal{{/}}">
        <confirmDialog />
        <popupMenu />
        <blockEditForm
          idBasis="ntb-block"
          parentClass="ntb-components"
          verticalOffset="110"
          blockStyles={{ blockStyles }}
          allTags={{ allTags }}
        />
        <netLogoModel />
        <tangoBuilder
          playMode={{ playMode }}
          runtimeMode={{ runtimeMode }}
          popupMenu={{ popupMenu }}
          canUndo={{ canUndo }}
          canRedo={{ canRedo }}
          breeds={{ breeds }}
          isDebugMode={{ isDebugMode }}
          isSideBySide={{ isSideBySide }}
        />
      </div>
      """

  })

NetTangoSkeleton = { create }

export default NetTangoSkeleton
