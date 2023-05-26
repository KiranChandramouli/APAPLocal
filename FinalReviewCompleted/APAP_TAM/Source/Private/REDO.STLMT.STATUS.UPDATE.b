* @ValidationCode : MjotMTc0MTc2MTM5OkNwMTI1MjoxNjg0ODQyMTMxODk3OklUU1M6LTE6LTE6LTIxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 23 May 2023 17:12:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -21
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.STLMT.STATUS.UPDATE
*******************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : DHAMU S
* Program Name : REDO.STLMT.STATUS.UPDATE
*****************************************************************
*Description:This routine is to update the status and response code based on the error message
***********************************************************************************************
*In parameter :None
*Out parameter :None
***********************************************************************************************
*Modification History:
*     Date            Who                  Reference               Description
*    ------          ------               -----------             --------------
*   3-12-2010       DHAMU S              ODR-2010-08-0469         Initial Creation
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.VISA.STLMT.05TO37
    $INSERT I_F.REDO.DC.STLMT.ERR.CODE
    $INSERT I_F.REDO.VISA.OUTGOING
 
    GOSUB PROCESS
RETURN
********
PROCESS:
*******

    IF ERROR.MESSAGE EQ '' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS> = "SETTLED"
    END
    IF ERROR.MESSAGE NE '' AND ERROR.MESSAGE NE 'USAGE.CODE' THEN
        GOSUB ERROR.CHECK
    END
    IF ERROR.MESSAGE EQ 'USAGE.CODE' THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS>    = "REPRESENTMENT"
        R.REDO.STLMT.LINE<VISA.SETTLE.CHARGEBACK.SENT> = 'N'
    END

 

RETURN
*************************************************************
ERROR.CHECK:
*************************************************************

    LOCATE ERROR.MESSAGE IN R.REDO.DC.STLMT.ERR.CODE<STM.ERR.CODE.ERR.MSG,1> SETTING ERROR.POS THEN
        R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS> = "REJECTED"
        R.REDO.STLMT.LINE<VISA.SETTLE.REASON.CODE> = R.REDO.DC.STLMT.ERR.CODE<STM.ERR.CODE.ERR.CODE,ERROR.POS>
        AUTO.CHG.BACK =  R.REDO.DC.STLMT.ERR.CODE<STM.ERR.CODE.AUTO.CHGBCK.FLAG,ERROR.POS>

        IF AUTO.CHG.BACK EQ 'YES' THEN
            GOSUB CASE.STATEMENT
            R.VISA.OUTGOING = R.REDO.STLMT.LINE
            R.VISA.OUTGOING<VISA.OUT.TRANSACTION.CODE> = TC.CODE.ALT
            R.REDO.STLMT.LINE<VISA.SETTLE.CHARGEBACK.SENT> = 'Y'
            R.REDO.STLMT.LINE<VISA.SETTLE.FINAL.STATUS> ='CHARGEBACK'
        END ELSE
            R.REDO.STLMT.LINE<VISA.SETTLE.CHARGEBACK.SENT> = 'N'
            R.REDO.STLMT.LINE<VISA.SETTLE.MAN.AUTO>='M'
        END
    END ELSE
        R.REDO.STLMT.LINE<VISA.SETTLE.CHARGEBACK.SENT> = 'N'
        R.REDO.STLMT.LINE<VISA.SETTLE.MAN.AUTO>='M'
    END


RETURN

*************************************************************
CASE.STATEMENT:
*************************************************************

    BEGIN CASE
        CASE TC.CODE EQ 5
            TC.CODE.ALT ='15'
        CASE TC.CODE EQ 6
            TC.CODE.ALT = '16'
        CASE TC.CODE EQ 7
            TC.CODE.ALT = '17'
    END CASE

RETURN

END
