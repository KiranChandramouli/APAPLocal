* @ValidationCode : MjotMTk2NTU2NTIzOTpDcDEyNTI6MTY4MTgwMjUxMjU2NDpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 Apr 2023 12:51:52
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.PRODUCE.RETURN.CHQ(Y.DATA)
*-------------------------------------------------------------
*Description: This nofile enquiry is to produce the Deal slip for
* APAP inward return chq.
*-------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*18-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*18-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_RC.COMMON
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

    GOSUB PROCESS
RETURN
*-------------------------------------------------------------
PROCESS:
*-------------------------------------------------------------


    FN.REDO.APAP.CLEARING.INWARD = 'F.REDO.APAP.CLEARING.INWARD'
    F.REDO.APAP.CLEARING.INWARD  = ''
    CALL OPF(FN.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD)


    LOCATE 'RECORD.ID' IN D.FIELDS<1> SETTING POS1 THEN
        Y.RCI.ID = D.RANGE.AND.VALUE<POS1>
    END ELSE
        ENQ.ERROR = 'SELECTION FIELD NOT FOUND'
        RETURN
    END

    CALL F.READ(FN.REDO.APAP.CLEARING.INWARD,Y.RCI.ID,R.RCI,F.REDO.APAP.CLEARING.INWARD,RCI.ERR)

    IF R.RCI ELSE
        ENQ.ERROR = 'REFERENCIA DE TRANSACCION NO ENCONTRADA'
        RETURN
    END
    IF R.RCI<CLEAR.CHQ.STATUS> NE 'REJECTED' THEN
        ENQ.ERROR = 'NOT RETURNED CHEQUE'
        RETURN
    END

    MATBUILD R.NEW.BKP FROM R.NEW
    ID.NEW.BKP = ID.NEW
    ID.NEW     = Y.RCI.ID
    MATPARSE R.NEW FROM R.RCI

    OFS$DEAL.SLIP.PRINTING = 1
    DEALSLIP.ID = 'REDO.REJ.CHQ'
    CALL PRODUCE.DEAL.SLIP(DEALSLIP.ID)
    Y.DATA =  Y.RCI.ID :" - COMPROBANTE IMPRESA"
    MATPARSE R.NEW FROM R.NEW.BKP
    ID.NEW = ID.NEW.BKP
    GET.FIRST.ID = FIELD(C$LAST.HOLD.ID,',',1)
    C$LAST.HOLD.ID = GET.FIRST.ID:',':C$LAST.HOLD.ID
RETURN
END
