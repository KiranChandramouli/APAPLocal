$PACKAGE APAP.TAM
SUBROUTINE REDO.R.BCR.REPORT.CHECK.TSA(Y.RESPONSE)
*-----------------------------------------------------------------------------
* INTERFACE: REDO.BCR.REPORT (Buro de Credito)
* Allows to check if the service REDO.BCR.REPORT.GEN is running
* @author youremail@temenos.com
* @stereotype subroutine
* @package infra.eb
* @parameters
*             Y.RESPONSE    (out)    0 is  NOT running, 1 is running
* OUTPUT
* -----------------
*             E             (out)    Error message

** 13-04-2023 R22 Auto Conversion no changes
** 13-04-2023 Skanda R22 Manual Conversion - No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TSA.SERVICE
    $INSERT I_F.COMPANY
*-----------------------------------------------------------------------------
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    R.TSA.SERVICE = ''
    Y.TSA.SERVICE.ID = R.COMPANY(EB.COM.MNEMONIC) :'/REDO.BCR.REPORT.GEN'

*  READ R.TSA.SERVICE FROM F.TSA.SERVICE, Y.TSA.SERVICE.ID ELSE ;*Tus Start
    CALL F.READ(FN.TSA.SERVICE,Y.TSA.SERVICE.ID,R.TSA.SERVICE,F.TSA.SERVICE,R.TSA.SERVICE.ERR)
    IF R.TSA.SERVICE.ERR THEN  ;* Tus End
        E = "REDO.BCR.RECORD.NOT.FOUND"
        E<2> = Y.TSA.SERVICE.ID : @VM : FN.TSA.SERVICE
        RETURN
    END

    IF R.TSA.SERVICE<TS.TSM.SERVICE.CONTROL> EQ 'START' THEN
        Y.RESPONSE = '1'
    END


RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
    FN.TSA.SERVICE = 'F.TSA.SERVICE'
    F.TSA.SERVICE  = ''
    CALL OPF(FN.TSA.SERVICE, F.TSA.SERVICE)

    Y.RESPONSE = '0'
RETURN

*-----------------------------------------------------------------------------
END
