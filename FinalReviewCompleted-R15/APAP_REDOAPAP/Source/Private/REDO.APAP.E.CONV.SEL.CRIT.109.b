* @ValidationCode : MjotNTAzNTc3MTA1OkNwMTI1MjoxNjg0ODM2MDM3OTMzOklUU1M6LTE6LTE6LTY6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 15:30:37
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -6
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.CONV.SEL.CRIT.109
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.E.CONV.SEL.CRIT.109
*--------------------------------------------------------------------------------------------------------
*Description       :  REDO.APAP.E.CONV.SEL.CRIT.109 is a conversion routine attached to the enquiries REDO.APAP.ENQ.INVST.DEADLINE.RPT
*                     and REDO.APAP.ER.INVST.DEADLINE.RPT, the routine fetches the value from O.DATA delimited
*                     with stars and formats them according to the selection criteria and returns
*                     the value back to O.DATA
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who             Reference                 Description
*     ------         -----           -------------            -------------
*    14 Sep 2010   MD Preethi      ODR-2010-03-0118 109      Initial creation
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------





*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


*MAIN.PARA:
***********
    GOSUB PROCESS.PARA
RETURN

PROCESS.PARA:
**************
    Y.EXP.DATE = FIELD(O.DATA,'*',1,1)
    Y.AGENCY = FIELD(O.DATA,'*',2,1)
    Y.INVST.TYPE = FIELD(O.DATA,'*',3,1)
    IF Y.EXP.DATE THEN
        Y.CRITERIA:= "Expiration date - ":Y.EXP.DATE:" "
    END
    IF Y.AGENCY THEN
        Y.CRITERIA:= "Agency - ":Y.AGENCY:" "
    END
    IF Y.INVST.TYPE THEN
        Y.CRITERIA:= "Investment Type - ":Y.INVST.TYPE
    END
    O.DATA = Y.CRITERIA

RETURN
END
