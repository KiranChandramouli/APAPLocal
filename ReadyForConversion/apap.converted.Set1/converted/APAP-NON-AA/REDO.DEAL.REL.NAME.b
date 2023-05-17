SUBROUTINE REDO.DEAL.REL.NAME(Y.OUTPUT)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.DEAL.REL.NAME
*--------------------------------------------------------------------------------------------------------
*Description       : This routine attached to an Deal Slip, the routine fetches the customer
*                    name from CUSTOMER Application based upon the values of type of client
*                    and it returns the value back to O.DATA
*Linked With       : DEAL.SLIP>REDO.REINV.FT
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    04-Apr-2011        H Ganesh                PACS00030247 - N.11       Initial Draft
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.RELATION.CUSTOMER
    $INSERT I_F.TELLER
    $INSERT I_F.ACCOUNT
    $INSERT I_F.RELATION

    GOSUB INITIALIZE
    GOSUB OPENING
    GOSUB FIELD.CHECK
    GOSUB GOEND
RETURN

*------------
INITIALIZE:

* The variables are initialized here

    REF.POS = ''
    CONCAT1 = ''
    Y.FANAL.VAL = ''
RETURN

*-------------
OPENING:

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.RELATION = 'F.RELATION'
    F.RELATION = ''
    CALL OPF(FN.RELATION,F.RELATION)

    Y.APPL = 'CUSTOMER'
    Y.FIELDS = 'L.CU.TIPO.CL'
    Y.POS = ''
    CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELDS,Y.POS)
    Y.L.CU.TIPO.CL.POS = Y.POS<1,1>
RETURN

*--------------
FIELD.CHECK:
*--------------

    IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
        Y.ACC.ID = R.NEW(FT.DEBIT.ACCT.NO)
    END
    IF APPLICATION EQ 'TELLER' THEN
        Y.ACC.ID = R.NEW(TT.TE.ACCOUNT.2)
    END

    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,F.ERR)

    Y.ACC.CLIENT.CODE = R.ACCOUNT<AC.CUSTOMER>
    CALL F.READ(FN.CUSTOMER,Y.ACC.CLIENT.CODE,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)
    Y.NAME1 = ''
    Y.ACC.REL.DESC = ''
    Y.NAME2 = ''
    Y.NAME3 = ''
    Y.ACC.CLIENT.TYPE = R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>


    IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
        Y.NAME1 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
    END ELSE
        IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
            Y.NAME1 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
        END
    END

    IF NOT(R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS>) THEN
        Y.NAME = R.CUSTOMER<EB.CUS.SHORT.NAME>
        Y.SPANISH.NAME = FIELD(Y.NAME,@VM,2)
        IF Y.SPANISH.NAME NE '' THEN
            Y.NAME1 = FIELD(Y.NAME,@VM,2)
        END
        IF Y.SPANISH.NAME EQ '' THEN
            Y.NAME1 = FIELD(Y.NAME,@VM,1)
        END
    END
    GOSUB GET.RELATION.CODE
RETURN

*-------------------
GET.RELATION.CODE:

    Y.ACC.REL.CODE = R.ACCOUNT<AC.RELATION.CODE>
    Y.ACC.REL.CODE = CHANGE(Y.ACC.REL.CODE,@VM,@FM)
    Y.CNT = DCOUNT(Y.ACC.REL.CODE,@FM)
    LOOP.CNTR = 1
    LOOP
    WHILE LOOP.CNTR LE Y.CNT
        Y.VAR = Y.ACC.REL.CODE<LOOP.CNTR>
        IF Y.VAR GE 500 AND Y.VAR LE 529 THEN

            CALL F.READ(FN.RELATION,Y.VAR,R.RELATION,F.RELATION,REL.ERR)
            Y.ACC.REL.DESC = R.RELATION<EB.REL.DESCRIPTION>: ' '
            Y.ACC.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER,LOOP.CNTR>

            CALL F.READ(FN.CUSTOMER,Y.ACC.JOINT.HOLD,R.CUSTOMER,F.CUSTOMER,CUSTOMER.ERR)

            IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA FISICA" OR R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "CLIENTE MENOR" THEN
                Y.NAME2 = R.CUSTOMER<EB.CUS.GIVEN.NAMES>:" ":R.CUSTOMER<EB.CUS.FAMILY.NAME>
            END ELSE
                IF R.CUSTOMER<EB.CUS.LOCAL.REF,Y.L.CU.TIPO.CL.POS> EQ "PERSONA JURIDICA" THEN
                    Y.NAME2 = R.CUSTOMER<EB.CUS.NAME.1,1>:" ":R.CUSTOMER<EB.CUS.NAME.2,1>
                END
            END
            Y.NAME3 = Y.NAME2
            Y.NAME2 = ''

            Y.FANAL.VAL<-1> = Y.ACC.REL.DESC: ' ' :Y.NAME3:' '
        END
        LOOP.CNTR + =1
    REPEAT
    GOSUB GOEND
RETURN

*---------------
GOEND:
    Y.NAME3 = CHANGE(Y.NAME3,@FM,' ')
*    Y.ACC.REL.DESC = CHANGE(Y.ACC.REL.DESC,FM, '')
*    O.DATA = Y.NAME1: ' ' :Y.ACC.REL.DESC: ' ':Y.NAME3
    Y.FANAL.VAL = CHANGE(Y.FANAL.VAL,@FM,'')
    Y.OUTPUT = Y.NAME1: ' ' :Y.FANAL.VAL
    Y.FANAL.VAL = ''
*---------------------------------------------------------------------------
END
