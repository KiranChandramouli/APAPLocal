* @ValidationCode : MjotMzkzNjA4MjgwOkNwMTI1MjoxNjgxMjk1NzE5Mzc0OmFqaXRoOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 16:05:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ajith
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOAPAP
SUBROUTINE REDO.APAP.E.BLD.CUS.DAO(Y.ENQ.DTLS)
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Pradeep M
* Program Name  : REDO.APAP.E.BLD.CUS.DAO
*-------------------------------------------------------------------------
* Description: This is the Biuld routime for the application CUSTOMER
*-------------------------------------------------------------------------
* Linked with   : ENQUIRY>REDO.CUST.DAO
* In parameter  : Y.ENQ.DTLS
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 16-10-11            ODR-2011-08-0055
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*12-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   F.READ to CACHE.READ , FM to @FM , SM to @SM
*12-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------



*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.USER
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN

OPEN.FILES:
*----------


    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''

    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.USER='F.USER'
    F.USER=''

    CALL OPF(FN.USER,F.USER)

RETURN

PROCESS:
*-------

    CALL CACHE.READ(FN.USER, OPERATOR, R.USER, ERR.USER) ;*R22 AUTO CODE CONVERSION
    Y.DPT.OFFCR=R.USER<EB.USE.DEPARTMENT.CODE>

    SEL.LIST=''
    NO.OF.REC=''
    ERR.SLIST=''

    SEL.CMD="SELECT ":FN.CUSTOMER: " WITH ACCOUNT.OFFICER EQ ":Y.DPT.OFFCR
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,ERR.SLIST)

    CHANGE @FM TO @SM IN SEL.LIST

    Y.ENQ.DTLS<2> = '@ID'
    Y.ENQ.DTLS<3> = 'EQ'
    Y.ENQ.DTLS<4> = SEL.LIST

RETURN

END
