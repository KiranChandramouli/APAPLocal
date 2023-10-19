* @ValidationCode : MjozNjkzNDg0NTpDcDEyNTI6MTY4MjA3ODg3MTcxNDpJVFNTOi0xOi0xOi0yMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 17:37:51
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -20
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.LIST.TRANS.CR.ACCT(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.E.ELIM.LOAN.PRODUCT
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*12/09/11      PACS00125978             Prabhu N                MODIFICAION
*
* 18-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, SM to @SM, IF Condition added
* 18-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_System
    $INSERT I_EB.EXTERNAL.COMMON
    $INSERT I_F.CUSTOMER.ACCOUNT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.FUNDS.TRANSFER

    GOSUB INITIALISE
    GOSUB SEND.LIST.ACCTS
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------


    CUSTOMER.ACCTS = System.getVariable("EXT.CUSTOMER.ACCOUNTS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        CUSTOMER.ACCTS = ""
    END					;*R22 Auto conversion - END
    SELECTED.ACCT = System.getVariable("CURRENT.DEBIT.ACCT.NO")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        SELECTED.ACCT = ""
    END					;*R22 Auto conversion - END


    CHANGE @SM TO @FM IN CUSTOMER.ACCTS

    LOCATE SELECTED.ACCT IN CUSTOMER.ACCTS SETTING SEL.ACCT.POS THEN
        DEL CUSTOMER.ACCTS<SEL.ACCT.POS>

    END

RETURN
*----------------------------------------------------------------------------
SEND.LIST.ACCTS:
*-----------------------------------------------------------------------------

    CHANGE @FM TO ' ' IN CUSTOMER.ACCTS
    ENQ.DATA<2,1>='@ID'
    ENQ.DATA<3,1>='EQ'
    ENQ.DATA<4,1>=CUSTOMER.ACCTS

RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
