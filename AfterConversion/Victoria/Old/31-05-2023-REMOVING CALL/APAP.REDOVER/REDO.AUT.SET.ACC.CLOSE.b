* @ValidationCode : MjoxNzQzNzI3MzEyOkNwMTI1MjoxNjgyNDEyMzI2OTUzOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 25 Apr 2023 14:15:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.SET.ACC.CLOSE
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.AUT.SET.ACC.CLOSE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.AUT.SET.ACC.CLOSE is a auth routine to generate a interest liq account close
*                    enquiry
*In  Parameter     : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                         Reference                   Description
*   ------             -----                       -------------             -------------
* 27 Dec 2011       Sudharsanan S                  PACS00164588             Initial Creation
*04-04-2023         Conversion Tool            R22 Auto Code conversion        No Changes
*04-04-2023            Samaran T                Manual R22 Code Conversion     No Changes
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AZ.ACCOUNT

    Y.INP = 'ENQ REDO.LIQ.ACCT.CLOSURE @ID EQ ':ID.NEW
    CALL EB.SET.NEW.TASK(Y.INP)
RETURN
END
