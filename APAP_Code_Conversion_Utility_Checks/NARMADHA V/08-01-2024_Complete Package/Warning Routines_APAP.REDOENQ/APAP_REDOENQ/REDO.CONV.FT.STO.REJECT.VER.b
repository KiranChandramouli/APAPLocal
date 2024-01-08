* @ValidationCode : MjoxNjQzOTUwNzgzOlVURi04OjE3MDMyMzQxODk4MzU6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 22 Dec 2023 14:06:29
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.FT.STO.REJECT.VER
*--------------------------------------------------------------------------
* DESCRIPTION: This routine is used to populate the reverse versions
*-------------------------------------------------------------------------------------
* Modification History
* DATE         NAME          Reference        REASON
* 10-02-2012   SUDHARSANAN   PACS00178947     Initial creation
*
* 13-APR-2023     Conversion tool    R22 Auto conversion       No changes
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
* 22-12-2023      Narmadha V        Manual R22 Conversion      F.READ to CACHE.READ
*---------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_GTS.COMMON
    $INSERT I_F.AI.REDO.PRINT.TXN.PARAM
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.STANDING.ORDER

    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN

***********
OPEN.FILES:
***********

    FN.AI.REDO.PRINT.TXN.PARAM = 'F.AI.REDO.PRINT.TXN.PARAM'
    F.AI.REDO.PRINT.TXN.PARAM = ''
    CALL OPF(FN.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER$NAU'
    F.FUNDS.TRANSFER  = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.STANDING.ORDER = 'F.STANDING.ORDER$NAU'
    F.STANDING.ORDER  =  ''
    CALL OPF(FN.STANDING.ORDER,F.STANDING.ORDER)
RETURN
**********
PROCESS:
*********

    Y.TXN.ID = O.DATA
    IF Y.TXN.ID[1,2] EQ 'FT' THEN
        CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,FUNDS.TRANSFER.ERR)
        Y.TXN.CODE  = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
* CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,Y.TXN.CODE,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
        CALL CACHE.READ(FN.AI.REDO.PRINT.TXN.PARAM,Y.TXN.CODE,R.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR) ;*Manual R22 Conversion - F.READ to CACHE
        Y.FT.REJ.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.FT.REJECT.VERSION>
        O.DATA = 'COS ':Y.FT.REJ.COS
    END ELSE
*CALL F.READ(FN.STANDING.ORDER,Y.TXN.ID,R.STANDING.ORDER,F.STANDING.ORDER,STANDING.ORDER.ERR)
        CALL CACHE.READ(FN.STANDING.ORDER,Y.TXN.ID,R.STANDING.ORDER,STANDING.ORDER.ERR) ;*Manual R22 Conversion - F.READ to CACHE.READ
        Y.TXN.CODE  = R.STANDING.ORDER<STO.PAY.METHOD>
        CALL F.READ(FN.AI.REDO.PRINT.TXN.PARAM,Y.TXN.CODE,R.AI.REDO.PRINT.TXN.PARAM,F.AI.REDO.PRINT.TXN.PARAM,PARAM.ERR)
        Y.STO.REJ.COS = R.AI.REDO.PRINT.TXN.PARAM<AI.PRI.STO.REJECT.VERSION>
        O.DATA = 'COS ':Y.STO.REJ.COS
    END

RETURN
*-------------------------------------------------------------------------------------------------------------------
END
