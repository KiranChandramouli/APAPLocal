* @ValidationCode : MjozNDc4NzY0MDpDcDEyNTI6MTY4MjA3MzM4MzE0MTpJVFNTOi0xOi0xOi0yMDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:23
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
SUBROUTINE REDO.E.GET.DCARD.DETAILS(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name :
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*26/08/11      PACS00112995          Prabhu N                MODIFICAION
* 17-APR-2023     Conversion tool    R22 Auto conversion      IF Condition added
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
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
    GOSUB GET.CARD.RENEW.DETAILS
RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

    CARD.RENEW.ID=''

    CUSTOMER.ID = System.getVariable("EXT.SMS.CUSTOMERS")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        CUSTOMER.ID = ""
    END					;*R22 Auto conversion - END

    ACCT.NO = System.getVariable("CURRENT.ACCT.NO")
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN ;*R22 Auto conversion - START
        ACCT.NO = ""
    END					;*R22 Auto conversion -END

    CARD.RENEW.ID=CUSTOMER.ID:"-":ACCT.NO

RETURN
*----------------------------------------------------------------------------
GET.CARD.RENEW.DETAILS:
*-----------------------------------------------------------------------------


    IF CARD.RENEW.ID THEN

        ENQ.DATA<2,1>='@ID'
        ENQ.DATA<3,1>='EQ'
        ENQ.DATA<4,1>= CARD.RENEW.ID
    END

RETURN
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
