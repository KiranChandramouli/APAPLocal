*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.AZ.ACC.MODE.PARAM
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.INP.AZ.ACC.MODE.PARAM
* ODR NUMBER    : ODR-2009-10-0795
*-------------------------------------------------------------------------------------------------
* Description   : This routine is used in AZ.ACCOUNT Version to default local fields related to payment mode
* In parameter  : none
* out parameter : none
*-------------------------------------------------------------------------------------------------
* Modification History :
*-------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 14-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
*-------------------------------------------------------------------------------------------------A
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.PAY.MODE.PARAM
$INSERT I_F.AZ.ACCOUNT
$INSERT I_F.ACCOUNT
$INSERT I_F.USER

  GOSUB INITIALSE
  GOSUB CHECK.PAY.MODE
  GOSUB PROGRAM.END

  RETURN
*----------------------------------------------------------------------
*~~~~~~~~~
INITIALSE:
*~~~~~~~~~

  FN.PAY.MODE.PARAM = 'F.REDO.H.PAY.MODE.PARAM'
  F.PAY.MODE.PARAM = ''
  R.PAY.MODE.PARAM = ''
  CALL OPF(FN.PAY.MODE.PARAM,F.PAY.MODE.PARAM)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  APPLN = 'AZ.ACCOUNT':FM:'ACCOUNT'
  Y.FIELDS = 'L.TYPE.INT.PAY':FM:'L.AC.PAYMT.MODE'
  CALL MULTI.GET.LOC.REF(APPLN,Y.FIELDS,POS.MODE)
  Y.PS.AZ = POS.MODE<1,1>
  Y.PZ.AC = POS.MODE<2,1>

  RETURN
*----------------------------------------------------------------------
CHECK.PAY.MODE:
*----------------------------------------------------------------------
  Y.PAY.MODE = R.NEW(AZ.LOCAL.REF)<1,Y.PS.AZ>

  IF Y.PAY.MODE EQ 'Reinvested' THEN
    RETURN
  END

  IF Y.PAY.MODE THEN
    CALL CACHE.READ(FN.PAY.MODE.PARAM,'SYSTEM',R.PAY.MODE.PARAM,ERR.MPAR)
    Y.PAY.MODE.PAR = R.PAY.MODE.PARAM<REDO.H.PAY.PAYMENT.MODE>

    LOCATE Y.PAY.MODE IN Y.PAY.MODE.PAR<1,1> SETTING POS THEN
      R.NEW(AZ.INTEREST.LIQU.ACCT) = R.PAY.MODE.PARAM<REDO.H.PAY.ACCOUNT.NO,POS>

      CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACC,F.ACCOUNT,ACC.ERR)
      R.ACC<AC.INTEREST.LIQU.ACCT> = R.PAY.MODE.PARAM<REDO.H.PAY.ACCOUNT.NO,POS>
      R.ACC<AC.LOCAL.REF,Y.PZ.AC> = Y.PAY.MODE

      TEMPTIME = OCONV(TIME(),"MTS")
      TEMPTIME = TEMPTIME[1,5]
      CHANGE ':' TO '' IN TEMPTIME
      CHECK.DATE = DATE()
      R.ACC<AC.RECORD.STATUS> = ''
      R.ACC<AC.DATE.TIME> = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
      R.ACC<AC.CURR.NO>=R.ACC<AC.CURR.NO>+1
      R.ACC<AC.INPUTTER>=TNO:'_':OPERATOR
      R.ACC<AC.AUTHORISER>=TNO:'_':OPERATOR
      R.ACC<AC.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
      R.ACC<AC.CO.CODE>=ID.COMPANY

      CALL F.WRITE(FN.ACCOUNT,ID.NEW,R.ACC)

    END ELSE
      R.NEW(AZ.INTEREST.LIQU.ACCT) = ''

      CALL F.READ(FN.ACCOUNT,ID.NEW,R.ACC,F.ACCOUNT,ACC.ERR)
      R.ACC<AC.INTEREST.LIQU.ACCT> = ''
      R.ACC<AC.LOCAL.REF,Y.PZ.AC> = ''

      TEMPTIME = OCONV(TIME(),"MTS")
      TEMPTIME = TEMPTIME[1,5]
      CHANGE ':' TO '' IN TEMPTIME
      CHECK.DATE = DATE()
      R.ACC<AC.RECORD.STATUS> = ''
      R.ACC<AC.DATE.TIME> = OCONV(CHECK.DATE,"DY2"):FMT(OCONV(CHECK.DATE,"DM"),"R%2"):OCONV(CHECK.DATE,"DD"):TEMPTIME
      R.ACC<AC.CURR.NO>=R.ACC<AC.CURR.NO>+1
      R.ACC<AC.INPUTTER>=TNO:'_':OPERATOR
      R.ACC<AC.AUTHORISER>=TNO:'_':OPERATOR
      R.ACC<AC.DEPT.CODE>=R.USER<EB.USE.DEPARTMENT.CODE>
      R.ACC<AC.CO.CODE>=ID.COMPANY

      CALL F.WRITE(FN.ACCOUNT,ID.NEW,R.ACC)
    END

  END

  RETURN
*----------------------------------------------------------------------
PROGRAM.END:

END
