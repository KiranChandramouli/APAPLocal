SUBROUTINE REDO.AZ.ROLLOVER.DEFAULT
*--------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Program Name : REDO.AZ.ROLLOVER.DEFAULT
*--------------------------------------------------------------------------------
* Description: This is autom content routine to default the values.
*
*
*-----------------------------------------------------------------------------
* Modification History :
*-----------------------------------------------------------------------------
*
*  DATE             WHO         REFERENCE            DESCRIPTION
* 23-Jun-2011    H GANESH      PACS00033292 - N.16  INITIAL CREATION
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.AZ.ROLLOVER.DETAILS

    GOSUB OPENFILES
    GOSUB PROCESS
RETURN

*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
    FN.AZ.ACCOUNT='F.AZ.ACCOUNT'
    F.AZ.ACCOUNT=''
    CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER  = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
    Y.ACC.NO = ID.NEW
    CALL F.READ(FN.AZ.ACCOUNT,Y.ACC.NO,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.ERR)

    Y.CUSTOMER = R.AZ.ACCOUNT<AZ.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.CUSTOMER,R.CUSTOMER,F.CUSTOMER,CUS.ERR)
    Y.NAME = R.CUSTOMER<EB.CUS.NAME.1>
    CHANGE @VM TO ' ' IN Y.NAME
    Y.STREET = R.CUSTOMER<EB.CUS.STREET>
    CHANGE @VM TO ' ' IN Y.STREET
    Y.ADDRESS =  R.CUSTOMER<EB.CUS.ADDRESS>
    CHANGE @VM TO ' ' IN Y.ADDRESS
    CHANGE @SM TO ' ' IN Y.ADDRESS
    Y.TOWN.COUNTRY =  R.CUSTOMER<EB.CUS.TOWN.COUNTRY>
    CHANGE @VM TO ' ' IN Y.TOWN.COUNTRY
    Y.POST.CODE = R.CUSTOMER<EB.CUS.POST.CODE>
    CHANGE @VM TO ' ' IN Y.POST.CODE

    Y.VALUE.DATE=R.AZ.ACCOUNT<AZ.VALUE.DATE>
    Y.MATURITY.DATE=R.AZ.ACCOUNT<AZ.MATURITY.DATE>

    IF Y.VALUE.DATE NE '' AND Y.MATURITY.DATE NE '' THEN
        DAYS='C'
        CALL CDD('',Y.VALUE.DATE,Y.MATURITY.DATE,DAYS)
    END

    CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
    VAR.UNIQUE.ID=UNIQUE.TIME

    R.NEW(REDO.AZ.ROLL.DAYS)   = DAYS:'D'
    R.NEW(REDO.AZ.ROLL.ACCOUNT.NO) = Y.ACC.NO
    R.NEW(REDO.AZ.ROLL.ACCOUNT.NAME) = Y.NAME
    R.NEW(REDO.AZ.ROLL.STREET) = Y.STREET
    R.NEW(REDO.AZ.ROLL.ADDRESS) = Y.ADDRESS
    R.NEW(REDO.AZ.ROLL.TOWN.COUNTRY) = Y.TOWN.COUNTRY
    R.NEW(REDO.AZ.ROLL.POST.CODE) = Y.POST.CODE
    R.NEW(REDO.AZ.ROLL.TIMESTAMP) = VAR.UNIQUE.ID
RETURN
END
