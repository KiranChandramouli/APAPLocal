* @ValidationCode : MjotMTQ1NzA1MzIzNTpDcDEyNTI6MTcwNTA0NTg4MjEwNjozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 13:21:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE  REDO.STLMT.MERCH.CATEG
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.STLMT.BIN.ADD.DIGIT
*Date              : 23.11.2010
*-------------------------------------------------------------------------
*Description:
*--------------
*This routine should be attached to MERCHANT.CATEGORY
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*23/11/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
* 10.04.2023       Conversion Tool                R22              Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M                R22              Manual Conversion   - No changes
*

*------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.VISA.STLMT.FILE.PROCESS.COMMON
    $INSERT I_F.REDO.VISA.STLMT.PARAM
    $INSERT I_F.REDO.MERCHANT.CATEG



    IF ERROR.MESSAGE NE '' THEN
        RETURN
    END

    GOSUB PROCESS
RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

    CALL OPF(FN.REDO.MERCHANT.CATEG,F.REDO.MERCHANT.CATEG) ;*R22 Manual Conversion
    CALL F.READ(FN.REDO.MERCHANT.CATEG,Y.FIELD.VALUE,R.REDO.MERCHANT.CATEG,F.REDO.MERCHANT.CATEG,Y.MRC.ERR)
    IF R.REDO.MERCHANT.CATEG NE '' THEN
        MRCHNT.TYPE=R.REDO.MERCHANT.CATEG<REDO.MERCHANT.CATEG.MERCHANT.TYPE>
        LOCATE MRCHNT.TYPE IN R.REDO.VISA.STLMT.PARAM<VISA.STM.PARAM.MERCH.NO.AMT.VAL,POS.TC,1> SETTING CATEG.POS THEN
            FLAG=1
            AMT.CHECK="FALSE"
        END
    END ELSE
        ERROR.MESSAGE="NOT.VALID.MERCHANT"
    END
RETURN
END
