$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CONV.BLOT.USER
****************************************************
*Company Name: Asociacion Popular de Ahorros y Prestamos
*Program Name: REDO.E.CONV.BLOT.USER
************************************************************
*Description: This conversion routine returns the user name who creted the transaction.
************************************************************
*Modification Details:
*=====================
* Date          Who             Reference           Description
* ------        -----           -------------       -------------
* 04-NoV-2011   Pradeep S       PACS00163292        Initial Creation
* 11-APRIL-2023      Conversion Tool       R22 Auto Conversion - No changes
* 11-APRIL-2023      Harsha                R22 Manual Conversion - No changes  
*******************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER

    GOSUB INIT
    GOSUB PROCESS

RETURN

******
INIT:
******

    Y.TXN.ID = FIELD(O.DATA,";",1)
    Y.TXN.USER = ''

RETURN  ;* Return END

*********
PROCESS:
*********

    BEGIN CASE
        CASE Y.TXN.ID[1,2] EQ 'FX'
            GOSUB PROCESS.FX
        CASE Y.TXN.ID[1,2] EQ 'FT'
            GOSUB PROCESS.FT
        CASE Y.TXN.ID[1,2] EQ 'TT'
            GOSUB PROCESS.TT
    END CASE

    IF Y.TXN.USER THEN
        O.DATA = Y.TXN.USER
    END

RETURN  ;* Return PROCESS

************
PROCESS.FX:
************

    FN.APPL = 'F.FOREX'
    F.APPL  = ''

    FN.APPL.HIS = 'F.FOREX$HIS'
    F.APPL.HIS  = ''

    Y.LOC.APP = 'FOREX'
    Y.LOC.FLD = 'L.FX.TR.APAP'
    CALL MULTI.GET.LOC.REF(Y.LOC.APP,Y.LOC.FLD,Y.LOC.POS)
    Y.FX.TR.APAP.POS = Y.LOC.POS

    GOSUB OPEN.FILE

    GOSUB READ.FILE

    IF R.APPL.REC THEN
        Y.TXN.USER = R.APPL.REC<FX.LOCAL.REF,Y.FX.TR.APAP.POS>
    END

RETURN  ;* Return PROCESS.FX

************
PROCESS.FT:
************

    FN.APPL = 'F.FUNDS.TRANSFER'
    F.APPL  = ''

    FN.APPL.HIS = 'F.FUNDS.TRANSFER$HIS'
    F.APPL.HIS  = ''

    GOSUB OPEN.FILE

    GOSUB READ.FILE

    IF R.APPL.REC THEN
        Y.TXN.USER = FIELD(R.APPL.REC<FT.INPUTTER>,'_',2,1)
    END

RETURN  ;* Return PROCESS.FT

************
PROCESS.TT:
************

    FN.APPL = 'F.TELLER'
    F.APPL  = ''

    FN.APPL.HIS = 'F.TELLER$HIS'
    F.APPL.HIS  = ''

    GOSUB OPEN.FILE

    GOSUB READ.FILE

    IF R.APPL.REC THEN
        Y.TXN.USER = FIELD(R.APPL.REC<TT.TE.INPUTTER>,'_',2,1)
    END

RETURN  ;* Return PROCESS.TT

***********
OPEN.FILE:
***********

    CALL OPF(FN.APPL,F.APPL)
    CALL OPF(FN.APPL.HIS,F.APPL.HIS)

RETURN  ;*Return OPEN.FILE

***********
READ.FILE:
***********

    Y.TXN.ID.HIS = Y.TXN.ID:";1"
    R.APPL.REC  = ''
    CALL F.READ(FN.APPL.HIS,Y.TXN.ID.HIS,R.APPL.REC,F.APPL.HIS,ERR)
    IF ERR THEN
        CALL F.READ(FN.APPL,Y.TXN.ID,R.APPL.REC,F.APPL,ERR)
    END

RETURN  ;* Return READ.FILE
END
