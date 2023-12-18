* @ValidationCode : MjotNTQ0NzI0MDU4OkNwMTI1MjoxNzAyMzg0NDI2MDkwOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Dec 2023 18:03:46
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
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     X TO X.VAR
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*08-12-2023     SURESH             R22 MANUAL CODE CONVERISON  OPF TO OPEN
*----------------------------------------------------------------------------------------
SUBROUTINE REMOVE.ACCT.STMT

    $INSERT I_COMMON
    $INSERT I_EQUATE

    EXECUTE "COMO ON REMOVE.ACCT.STMT-":TODAY

    GOSUB INITIALISE
    GOSUB SELECT.RECORDS
    EXECUTE "COMO OFF REMOVE.ACCT.STMT-":TODAY
RETURN

INITIALISE:
**********
    FN.ACC = 'F.ACCOUNT'
    F.ACC = ''
    CALL OPF(FN.ACC,F.ACC)
    FN.ACCT.STMT = 'F.ACCOUNT.STATEMENT'
    F.ACCT.STMT = ''
    CALL OPF(FN.ACCT.STMT,F.ACCT.STMT)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'
    F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.SAVEDLISTS = '&SAVEDLISTS&'
    F.SAVEDLISTS = ''
*CALL OPF(FN.SAVEDLISTS,F.SAVEDLISTS)
    OPEN FN.SAVEDLISTS TO F.SAVEDLISTS ELSE
    END ;*R22 MANUAL CODE CONVERSION

    SEL.LIST = ''
    NO.OF.REC = ''
    RET.CODE = ''
    AC.REC = ''
    ECB.REC = ''

RETURN
SELECT.RECORDS:
**************

*READ SEL.LIST FROM F.SAVEDLISTS,'PROB.AS.LIST' ELSE
*SEL.LIST = ''
*END
    SEL.LIST<-1>="1023488817"
    SEL.LIST<-1>="1022641891"
    SEL.LIST<-1>="1022250906"
    SEL.LIST<-1>="1024523276"
    SEL.LIST<-1>="1023848554"
    SEL.LIST<-1>="1023850427"
    SEL.LIST<-1>="1023357763"
    SEL.LIST<-1>="1024091244"
    SEL.LIST<-1>="1023326094"
    SEL.LIST<-1>="1023532549"
    CNT = DCOUNT(SEL.LIST,@FM)
    FOR X.VAR = 1 TO CNT ;*R22 AUTO CONVERSION
        IF SEL.LIST<X.VAR> THEN ;*R22 AUTO CONVERSION
            ACC.ID = SEL.LIST<X.VAR> ;*R22 AUTO CONVERSION
            GOSUB PROCESS
        END
    NEXT X.VAR ;*R22 AUTO CONVERSION
RETURN

PROCESS:
********

    READ AC.REC FROM F.ACC,ACC.ID ELSE AC.REC = ''
    IF AC.REC EQ '' THEN
        CRT "Deleting account statement ": ACC.ID
        DELETE F.ACCT.STMT,ACC.ID
    END
RETURN
*--------------------------------------------------------------------
*Final End
END
