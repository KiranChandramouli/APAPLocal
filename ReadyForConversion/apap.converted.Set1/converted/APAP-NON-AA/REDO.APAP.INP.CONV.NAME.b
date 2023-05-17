SUBROUTINE REDO.APAP.INP.CONV.NAME
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :GANESH.R
*Program   Name    : REDO.APAP.INP.CONV.NAME
*Reference Number  : ODR-2010-08-0179
*---------------------------------------------------------------------------------

*DESCRIPTION       :This program is used to get the name and format them
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.SOLICITUD.CK

    GOSUB OPENFILE
    GOSUB PROCESS
RETURN

OPENFILE:
    FN.REDO.H.SOLICITUD.CK = 'F.REDO.H.SOLICITUD.CK'
    F.REDO.H.SOLICITUD.CK = ''
    CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

PROCESS:

    CALL F.READ(FN.REDO.H.SOLICITUD.CK,ID,R.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK,SOLICITUD.ERR)
    VAR.NAME = R.REDO.H.SOLICITUD.CK<REDO.H.SOL.INPUTTER>
    O.DATA = FIELD(VAR.NAME,'_',2)

RETURN
END
