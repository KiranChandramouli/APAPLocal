* @ValidationCode : MjoxMjAwNDQ3NTEwOkNwMTI1MjoxNjk4NDA1NTM5NjI5OklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Oct 2023 16:48:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI              MANUAL R23 CODE CONVERSION                 FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>100</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE ITSS.REDO.CH.CANALAFILF360(Y.LIST)
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    LOCATE "CUSTOMER.ID" IN D.FIELDS<1> SETTING POS.AC.NUMBER ELSE NULL
    Y.CUSTOMER.ID = D.RANGE.AND.VALUE<POS.AC.NUMBER>
    Y.LIST = ''
    Y.LIST.A=""
    CALL REDO.CH.CANALAFILF360(Y.LIST.A)

    FOR I=1 TO DCOUNT(Y.LIST.A,@FM)

        IF FIELDS(Y.LIST.A<I>,'*',1) NE 'APAPENLINEA' THEN
            Y.LIST<-1> = Y.LIST.A<I>
        END

    NEXT I

    FN.ITSS.IBSOLUTION.USER.CUSTOMER = "F.ITSS.IBSOLUTION.USER.CUSTOMER"
    F.ITSS.IBSOLUTION.USER.CUSTOMER = ""
    CALL OPF(FN.ITSS.IBSOLUTION.USER.CUSTOMER,F.ITSS.IBSOLUTION.USER.CUSTOMER)

    READ R.ITSS.IBSOLUTION.USER.CUSTOMER FROM F.ITSS.IBSOLUTION.USER.CUSTOMER, Y.CUSTOMER.ID  ELSE
        R.ITSS.IBSOLUTION.USER.CUSTOMER = ''
        RETURN
    END

    FN.ITSS.IBSOLUTION.USER = "F.ITSS.IBSOLUTION.USER"
    F.ITSS.IBSOLUTION.USER = ""
    CALL OPF(FN.ITSS.IBSOLUTION.USER,F.ITSS.IBSOLUTION.USER)

    FOR I=1 TO DCOUNT(R.ITSS.IBSOLUTION.USER.CUSTOMER,@FM)
        Y.LOGIN = R.ITSS.IBSOLUTION.USER.CUSTOMER<I>
        READ R.ITSS.IBSOLUTION.USER FROM F.ITSS.IBSOLUTION.USER,Y.LOGIN   ELSE
            R.ITSS.IBSOLUTION.USER = ''
            RETURN
        END
        IF R.ITSS.IBSOLUTION.USER NE '' THEN
            Y.TEMP = ''
            Y.TEMP<1> = 'APAPENLINEA'
            Y.TEMP<2> = 'YES'
            Y.TEMP<3> = R.ITSS.IBSOLUTION.USER<2>
            Y.TEMP<4> = Y.LOGIN
            Y.TEMP<5> = R.ITSS.IBSOLUTION.USER<7>
            Y.TEMP<6> = R.ITSS.IBSOLUTION.USER<8>
            Y.TEMP<7> =R.ITSS.IBSOLUTION.USER<9>
            CONVERT @FM TO '*' IN Y.TEMP
            Y.LIST<-1> = Y.TEMP
        END

    NEXT I
    RETURN
