*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.ACCOUNT.SEARCH.VP
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :PRABHU.N
*Program   Name    :REDO.V.VAL.ACCOUNT.SEARCH.VP
*---------------------------------------------------------------------------------

*DESCRIPTION       :It is attached as VALIDATION  routine in all the version used
*                  in the development N.83.It will fetch the value from sunnel interface
*                  and assigns it it R.NEW
*LINKED WITH       :

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 16-APR-2010        Prabhu.N       ODR-2009-10-0536   Initial Creation
* 03-DEC-2010        Prabhu.N       ODR-2010-11-0211    Modified based on Sunnel
* 12-JAN-2011        Kavitha.S      ODR-2010-11-0211    Added logic based on B.126 TFS
* 22-Jun-2011        Prabhu          ODR-2010-11-0211    Error message for closed card added
* 18-JUL-2011        Joaquin Costa  PACS00077556         Fix issues in FT validation
*
*-------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_System
$INSERT I_F.REDO.SUNNEL.PARAMETER

  IF VAL.TEXT NE '' OR MESSAGE EQ 'VAL' THEN
    RETURN
  END

  FN.REDO.SUNNEL.PARAMETER='F.REDO.SUNNEL.PARAMETER'
  F.REDO.SUNNEL.PARAMETER=''

  GOSUB INIT
  GOSUB CHECK.STATUS
  RETURN

*---------
INIT:
*---------
  LREF.APP = APPLICATION
  LREF.POS = ''
  IF APPLICATION EQ 'TELLER' THEN
    CALL REDO.V.VAL.ACCT.CREDIT.VP
    LREF.FIELDS='L.TT.CR.CARD.NO':VM:'L.TT.AC.STATUS'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.CARD.NO.POS      = LREF.POS<1,1>
    Y.CARD.ACCT.ST.POS = LREF.POS<1,2>
    VAR.CARD.NO = R.NEW(TT.TE.LOCAL.REF)<1,Y.CARD.NO.POS>
*GOSUB CHECK.SUNNEL
    CALL System.setVariable("CURRENT.CARD.NO",VAR.CARD.NO)
    VAR.CARD.NO = VAR.CARD.NO[1,6]:'******':VAR.CARD.NO[13,4]
    R.NEW(TT.TE.LOCAL.REF)<1,Y.CARD.NO.POS> = VAR.CARD.NO
    Y.CARD.ACCT.ST = R.NEW(TT.TE.LOCAL.REF)<1,Y.CARD.ACCT.ST.POS>
  END
  IF APPLICATION EQ 'FUNDS.TRANSFER' THEN
    CALL REDO.V.VAL.ACCT.CREDIT.VP
    LREF.FIELDS = 'L.FT.CR.CARD.NO':VM:'L.FT.AC.STATUS'
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
    Y.CARD.NO.POS      = LREF.POS<1,1>
    Y.CARD.ACCT.ST.POS = LREF.POS<1,2>
    VAR.CARD.NO = R.NEW(FT.LOCAL.REF)<1,Y.CARD.NO.POS>
    CALL System.setVariable("CURRENT.CARD.NO",VAR.CARD.NO)
    VAR.CARD.NO = VAR.CARD.NO[1,6]:'******':VAR.CARD.NO[13,4]
    R.NEW(FT.LOCAL.REF)<1,Y.CARD.NO.POS> = VAR.CARD.NO
    Y.CARD.ACCT.ST = R.NEW(FT.LOCAL.REF)<1,Y.CARD.ACCT.ST.POS>
  END
*    IF APPLICATION EQ "T24.FUND.SERVICES" THEN
*        Y.TXN.CODES = R.NEW(TFS.TRANSACTION)
*        CHANGE VM TO FM IN Y.TXN.CODES
*        LOCATE 'CREDCARDPAYMENT' IN Y.TXN.CODES<1> SETTING Y.TXN.POS ELSE
*            RETURN
*        END
*        Y.ARRAY = "BUSCAR_TARJETA_TFS_CA"
*        CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
*        LREF.FIELDS = 'L.TT.CR.CARD.NO':VM:'L.TT.AC.STATUS'
*        CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELDS,LREF.POS)
*        Y.CARD.NO.POS      = LREF.POS<1,1>
*        Y.CARD.ACCT.ST.POS = LREF.POS<1,2>
*        VAR.CARD.NO   = R.NEW(TFS.LOCAL.REF)<1,Y.CARD.NO.POS>
*        CALL System.setVariable("CURRENT.CARD.NO",VAR.CARD.NO)
*        VAR.CARD.NO   = VAR.CARD.NO[1,6]:'******':VAR.CARD.NO[13,4]
*        R.NEW(TFS.LOCAL.REF)<1,Y.CARD.NO.POS> = VAR.CARD.NO
*        Y.CARD.ACCT.ST = R.NEW(TFS.LOCAL.REF)<1,Y.CARD.ACCT.ST.POS>
*    END

  RETURN

*CHECK.SUNNEL
*
*   Y.ACCT      = COMI
*    Y.ACCT.NO   = ''
*    Y.CARD.TYPE = ''
*    CALL F.READ(FN.SUNNEL.DETAILS,Y.ACCT,R.SUNNEL.DETAILS,F.SUNNEL.DETAILS,SUNNEL.ERR)
*    IF NOT(R.SUNNEL.DETAILS) THEN
*        CALL REDO.GET.CARD.TYPE(VAR.CARD.NO,Y.ACCT,Y.CARD.TYPE)
*        R.SUNNEL.DETAILS<SUN.CARD.TYPE> = Y.CARD.TYPE
*        CALL F.WRITE(FN.SUNNEL.DETAILS,Y.ACCT,R.SUNNEL.DETAILS)
*    END
*    RETURN

*------------
CHECK.STATUS:
*------------
  CALL CACHE.READ(FN.REDO.SUNNEL.PARAMETER,'SYSTEM',R.REDO.SUNNEL.PARAMETER,ERR)
  Y.STATUS<2> = R.REDO.SUNNEL.PARAMETER<SP.CLOSED.STATUS>

  IF Y.CARD.ACCT.ST EQ Y.STATUS<2> THEN
    ETEXT="EB-REDO.CARD.CLOSED"
    CALL STORE.END.ERROR
  END
  RETURN
END
