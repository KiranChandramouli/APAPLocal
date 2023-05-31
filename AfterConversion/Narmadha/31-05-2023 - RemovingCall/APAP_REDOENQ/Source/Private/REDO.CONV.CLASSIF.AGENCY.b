* @ValidationCode : MjoxNDI1NDM3OTc2OkNwMTI1MjoxNjgyMDc4ODcxMjA0OklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CONV.CLASSIF.AGENCY
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CONV.AGENCY.DET
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.CLASSIFICATION is a conversion routine attached to the ENQUIRY>
*                    REDO.APAP.NOF.LINK.RPT, the routine fetches the value from O.DATA delimited
*                    with stars and formats them according to the selection criteria and returns the value
*                     back to O.DATA
*Linked With       :
*In  Parameter     : N/A
*Out Parameter     : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*--------------------------------------------------------------------------------------------------------
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 20 OCT 2010              Dhamu S             ODR-2010-03-0098            Initial Creation
** 18-APR-2023    	 Conversion tool    R22 Auto conversion          No changes
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************

    IF NOT(O.DATA) THEN
        O.DATA = "ALL"
    END ELSE
        O.DATA = "AGENCIA : ":O.DATA
    END


RETURN
END
*------------------------------------------------------------------------------------------------------
