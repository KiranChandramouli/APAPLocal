SUBROUTINE REDO.V.VAL.ACC.IMG.SEARCH
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ACCOUNT.SEARCH
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as authorization routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it it R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536   Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
*26-JUN-2011        Prabhu N       PACS00061657        modified to support error message
*-------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TELLER
    $INSERT I_F.CUSTOMER
    $INSERT I_F.REDO.SUNNEL.PARAMETER
    IF VAL.TEXT EQ '' THEN
        GOSUB INIT
        GOSUB PROCESS
        GOSUB CHECK.STATUS
    END
RETURN
*-----------
INIT:
*----------
    FN.CUSTOMER='F.CUSTOMER'
    F.CUSTOMER=''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.REDO.SUNNEL.PARAMETER='F.REDO.SUNNEL.PARAMETER'
    F.REDO.SUNNEL.PARAMETER=''

    LREF.APP='TELLER':@FM:'CUSTOMER'
    LREF.FIELDS='L.TT.CUS.IMAGE':@VM:'L.TT.CR.CARD.NO':@VM:'L.TT.CLIENT.COD':@VM:'L.TT.AC.STATUS':@FM:'L.CU.CIDENT'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)

RETURN
*--------
PROCESS:
*---------
    Y.ARRAY='BUSCAR_TARJETA_CUENTA.2'
    CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)

    Y.CU.CODE.POS    =LREF.POS<1,3>
    VAR.CUSTOMER=R.NEW(TT.TE.LOCAL.REF)<1,Y.CU.CODE.POS>
    CALL F.READ(FN.CUSTOMER,VAR.CUSTOMER,R.CUSTOMER,F.CUSTOMER,ERR)
    LREF.CUS.POS     =LREF.POS<2>
    VAR.CUS.IMAGE.POS=LREF.POS<1,1>
    VAR.CARD.POS     =LREF.POS<1,2>
    VAR.CEDULA='Padrone$':R.CUSTOMER<EB.CUS.LOCAL.REF><1,LREF.CUS.POS>
    CALLJ "com.padrone.ws.util.MainClass","callPadrone",VAR.CEDULA SETTING RET.CEDULA ON ERROR
    END
    CHANGE '#' TO @FM IN RET.CEDULA
    R.NEW(TT.TE.LOCAL.REF)<1,VAR.CUS.IMAGE.POS>=RET.CEDULA<7>
    VAR.CARD.NO=R.NEW(TT.TE.LOCAL.REF)<1,VAR.CARD.POS>
    VAR.CARD.NO=VAR.CARD.NO[1,6]:'******':VAR.CARD.NO[13,4]
    R.NEW(TT.TE.LOCAL.REF)<1,VAR.CARD.POS>=VAR.CARD.NO
RETURN
*-----------
CHECK.STATUS:
*------------
    Y.ST.POS=LREF.POS<1,4>
    Y.CARD.ACCT.ST=R.NEW(TT.TE.LOCAL.REF)<1,Y.ST.POS>
    CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,'SYSTEM',R.REDO.SUNNEL.PARAMETER,ERR)
    Y.STATUS<2>=R.REDO.SUNNEL.PARAMETER<SP.CLOSED.STATUS>

    IF Y.CARD.ACCT.ST EQ Y.STATUS<2> THEN
        ETEXT="EB-REDO.CARD.CLOSED"
        CALL STORE.END.ERROR
    END
RETURN
