$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.OVERDRAFT.ACCT.RTN.LOAD
*********************************************************************************************************
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Dev By       : V.P.Ashokkumar
*********************************************************************************************************
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-07-2023            Conversion Tool             R22 Auto Code conversion                     VM TO @VM,INSERT FILE MODIFIED
*13-07-2023              Samaran T                R22 Manual Code conversion                         No Changes
*----------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.CUSTOMER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CATEGORY
    $INSERT I_F.LIMIT
    $INSERT I_F.ACCOUNT.CLASS
    $INSERT I_F.DATES
    $INSERT I_REDO.B.OVERDRAFT.ACCT.RTN.COMMON  ;*R22 AUTO CODE CONVERSION.END

    GOSUB INITIALISE
    GOSUB OPENFILES
RETURN

INITIALISE:
***********
    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    FN.ACCOUNT = 'F.ACCOUNT';  F.ACCOUNT =  ''
    FN.CATEGORY = 'F.CATEGORY';  F.CATEGORY = ''
    FN.LIMIT =  'F.LIMIT';   F.LIMIT =  ''
    FN.ACCOUNT.CLASS = 'F.ACCOUNT.CLASS'; F.ACCOUNT.CLASS = ''
    FN.DR.OPER.OVERDRAF.WORKFILE = 'F.DR.OPER.OVERDRAF.WORKFILE'; F.DR.OPER.OVERDRAF.WORKFILE = ''
    FN.LATAM.CARD.CUSTOMER = 'F.LATAM.CARD.CUSTOMER'; F.LATAM.CARD.CUSTOMER = ''
    Y.CO.CODE = '';  Y.ACCOUNT.OFFICER = ''; Y.CUSTOMER=''; Y.OPENING.DATE = ''
    Y.CUSTOMER = ''; Y.CARD.ISSUE.ID = ''; Y.LOCKED.AMOUNT = ''; Y.LOCKED.AMOUNT  = ''
    Y.AVAILABLE.BALANCE = ''; Y.IN.TRANSIT.BALANCE = '' ;Y.ONLINE.CLEARED.BAL = ''

    LREF.POS    = ''; L.AC.STATUS1.POS = ''; L.AC.STATUS2.POS = ''; L.AC.AV.BAL.POS = ''
    LREF.APP    = 'ACCOUNT'
    LREF.FIELDS = 'L.AC.STATUS1':@VM:'L.AC.STATUS2':@VM:'L.AC.AV.BAL' ;*R22 AUTO CODE CONVERSION
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    L.AC.STATUS1.POS = LREF.POS<1,1>
    L.AC.STATUS2.POS = LREF.POS<1,2>
    L.AC.AV.BAL.POS = LREF.POS<1,3>
RETURN

OPENFILES:
**********
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    CALL OPF(FN.CATEGORY,F.CATEGORY)
    CALL OPF(FN.LIMIT,F.LIMIT)
    CALL OPF(FN.ACCOUNT.CLASS,F.ACCOUNT.CLASS)
    CALL OPF(FN.DR.OPER.OVERDRAF.WORKFILE,F.DR.OPER.OVERDRAF.WORKFILE)
    CALL OPF(FN.LATAM.CARD.CUSTOMER,F.LATAM.CARD.CUSTOMER)
RETURN

END
