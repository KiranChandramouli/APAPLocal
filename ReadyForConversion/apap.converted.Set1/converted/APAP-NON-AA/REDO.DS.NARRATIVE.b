SUBROUTINE REDO.DS.NARRATIVE(Y.COMENTARIO)
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :btorresalbornoz
*Program   Name    :REDO.DS.NARRATIVEDS
*---------------------------------------------------------------------------------
*DESCRIPTION       :This program is used to get the SELL DESTINATION value from EB.LOOKUP TABLE
* ----------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER

    GOSUB PROCESS
RETURN


********************************************************************************
PROCESS:
********************************************************************************



    Y.COMENTARIO = R.NEW(TT.TE.NARRATIVE.1)
    Y.COMENTARIO=Y.COMENTARIO[1,34]
    Y.COMENTARIO=FMT(Y.COMENTARIO,"R#34")

RETURN
END
