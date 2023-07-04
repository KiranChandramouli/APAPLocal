* @ValidationCode : MjotOTM3Mzk1ODExOkNwMTI1MjoxNjgxOTk1OTg1OTE5OklUU1M6LTE6LTE6LTEyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 20 Apr 2023 18:36:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BUILD.REGOFF(ENQ.DATA)

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.BUILD.REGOFF
*--------------------------------------------------------------------------------------------------------
*Description  : This is BUILD.ROUTINE to check the agency is valid for the user accessing the data
*Linked With  : REDO.RENEWAL.CARD.REGOFF
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 28 Sep 2011    Balagurunathan         PACS00131231          Initial Creation

* 13-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM
* 13-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER


    GOSUB MAIN.PROCESS


RETURN

INITIALISE:

    AGENCY=''
    COMP.LIST=''
RETURN


***************
MAIN.PROCESS:
***************

    FLDS.LIST=ENQ.DATA<2,1>

    LOCATE "AGENCY" IN FLDS.LIST<1,1> SETTING POS.FLDS THEN
        AGENCY=ENQ.DATA<4,POS.FLDS>

    END
    COMP.LIST=R.USER<EB.USE.COMPANY.CODE>

    IF AGENCY EQ '' THEN
        CHANGE @FM TO ' ' IN COMP.LIST
        ENQ.DATA<4,POS.FLDS>=COMP.LIST
        RETURN

    END


    LOCATE AGENCY IN COMP.LIST<1,1> SETTING POS.COMP THEN
        ENQ.DATA<4,POS.FLDS>= AGENCY

    END ELSE
        ENQ.ERROR='EB-CANNOT.ACCESS.COMPANY'
    END

    LOCATE "ALL" IN COMP.LIST<1,1> SETTING POS.COMP THEN
        ENQ.DATA<4,POS.FLDS>=''
        ENQ.ERROR=''
    END

RETURN


END
