*-----------------------------------------------------------------------------
* <Rating>-94</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.CL.VERIFY.DIS.AMOUNT
*
* ====================================================================================
*
*
* ====================================================================================
*
* Subroutine Type :
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :validate to disburstement wont greater than amount
*
*
* Incoming:
* ---------
*
*
*
* Outgoing:

* ---------
*
*
*-----------------------------------------------------------------------------------
*
*
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 26 2011
*
* Development by  : Jorge Valarezo (jvalarezoulloa@temenos.com) - RTAM
* Date            : 05 Jan 2011
* Notes           : Chages to validate if Type of Disbursment or Charge has value then them amount too
* Date            : 22 May 2011
* Notes           : set correct Subvalue Set
*=======================================================================
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.CREATE.ARRANGEMENT

$INSERT I_ENQUIRY.COMMON
*************************************************************************

  GOSUB INITIALISE

  GOSUB OPEN.FILES
  GOSUB PROCESS
  GOSUB CHECK.PRELIM.CONDITIONS




  RETURN

* ======
PROCESS:
* ======
  IF Y.DIS.AMOUNT.TOT GT Y.AMOUNT.TOT THEN
    AF = REDO.FC.DIS.AMT.TOT
    ETEXT = "EB-FC-DISB-GREAT-LOAN"
    CALL STORE.END.ERROR

  END ELSE
*WMEZA 13 FEB 12/ MG 09 ABR 12
    R.POLIZAS = R.NEW(REDO.FC.INS.POLICY.TYPE)
    X.POLIZAS = DCOUNT(R.POLIZAS, VM)
    X=1
    Y=1
    IF NOT(X.POLIZAS) THEN
      X.POLIZAS = 1
    END

    X = 1
    LOOP
    WHILE X LE X.POLIZAS
      Y.MONTO.P.T =  R.NEW(REDO.FC.INS.TOTAL.PREM.AMT)<1,X>

      IF R.NEW(REDO.FC.INS.MANAGEM.TYPE)<1,X> EQ 'NO INCLUIR EN CUOTA' AND Y.MONTO.P.T NE 0   THEN
        GOSUB LOCATE.PROPERTY
      END
*            GOSUB LOCATE.CHARGE
      X+=1
    REPEAT

    Y.DIS.CHARG = R.NEW(REDO.FC.CHARG.AMOUNT)
    Y.CHARG.DISC = R.NEW(REDO.FC.CHARG.DISC)

    Y.DIS.AMT.ALL=SUM(Y.DIS.AMT) + SUM(Y.DIS.CHARG)
    IF Y.DIS.AMT.ALL NE Y.DIS.AMOUNT.TOT THEN
      AF = REDO.FC.DIS.AMT
      ETEXT = "EB-FC-TYPE-DISBT-NO.SAME"
      CALL STORE.END.ERROR
    END


  END
  RETURN

*
* =========
LOCATE.PROPERTY:
* =========
*
  LOCATE R.NEW(REDO.FC.INS.PRI.PROPER)<1,X,1> IN LIST.PROP SETTING Y.COD.PROP THEN
    LOCATE R.NEW(REDO.FC.INS.PRI.PROPER)<1,X,1> IN R.NEW(REDO.FC.CHARG.DISC)<1,1> SETTING Y.COD.CARGO THEN
      R.NEW(REDO.FC.CHARG.AMOUNT)<1,Y.COD.CARGO> = Y.MONTO.P.T
    END ELSE
      LON.CARGOS = DCOUNT(R.NEW(REDO.FC.CHARG.DISC), VM)
      R.NEW(REDO.FC.CHARG.DISC)<1,LON.CARGOS+1> = R.NEW(REDO.FC.INS.PRI.PROPER)<1,X,1>
      R.NEW(REDO.FC.CHARG.AMOUNT)<1,LON.CARGOS+1> = Y.MONTO.P.T
    END
  END
  RETURN
*
* =========
LOCATE.CHARGE:
* =========
*
*      LOCATE R.NEW(REDO.FC.INS.PRI.PROPER)<1,X,1> IN LIST.PROP SETTING Y.COD.PROP THEN

  Y.LEN.CHARGES = DCOUNT(R.NEW(REDO.FC.INS.SEC.COM.TYPE), VM)
  Y.CONT.CHARGES = 1
  IF NOT(R.NEW(REDO.FC.INS.SEC.COM.TYPE)<1,X,1>) THEN
    RETURN
  END
  LOOP
  WHILE Y.CONT.CHARGES LE Y.LEN.CHARGES
    Y.MONTO.CHARGES = R.NEW(REDO.FC.INS.SEC.COM.AMT)<1,X,Y.CONT.CHARGES>
    IF NOT(Y.MONTO.CHARGES) THEN
      RETURN
    END

    LOCATE R.NEW(REDO.FC.INS.SEC.COM.TYPE)<1,X,Y.CONT.CHARGES> IN R.NEW(REDO.FC.CHARG.DISC)<1,1> SETTING Y.COD.CARGO THEN
      R.NEW(REDO.FC.CHARG.AMOUNT)<1,Y.COD.CARGO> = Y.MONTO.CHARGES
    END ELSE
      LON.CARGOS = DCOUNT(R.NEW(REDO.FC.CHARG.DISC), VM)
      R.NEW(REDO.FC.CHARG.DISC)<1,LON.CARGOS+1> = R.NEW(REDO.FC.INS.SEC.COM.TYPE)<1,X,Y.CONT.CHARGES>
      R.NEW(REDO.FC.CHARG.AMOUNT)<1,LON.CARGOS+1> = Y.MONTO.CHARGES
    END
    Y.CONT.CHARGES+=Y.CONT.CHARGES
  REPEAT
*      END
  RETURN
*
* =========
OPEN.FILES:
* =========
*

  RETURN
*
* =========
INITIALISE:
* =========
*
  LOOP.CNT        = 1
  MAX.LOOPS       = 1
  PROCESS.GOAHEAD = 1
  Y.AMOUNT.TOT = R.NEW(REDO.FC.AMOUNT)
  Y.DIS.AMOUNT.TOT = R.NEW(REDO.FC.DIS.AMT.TOT)
  Y.DIS.TYP = R.NEW(REDO.FC.DIS.TYPE)
  Y.DIS.AMT = R.NEW(REDO.FC.DIS.AMT)
  Y.DIS.CHARG = R.NEW(REDO.FC.CHARG.AMOUNT)
  Y.CHARG.DISC = R.NEW(REDO.FC.CHARG.DISC)
  Y.NUM.DIS.TYPE = DCOUNT (R.NEW(REDO.FC.DIS.TYPE),VM)
  Y.NUM.CHARG.DISC = DCOUNT (R.NEW(REDO.FC.CHARG.DISC),VM)

*WMEZA 13 FEB 12
  Y.COD.CARGO = '0'
  Y.COD.PROP = '0'
  LIST.PROP = ''
  Z = 1
  X = 1
  Y = 1
  D.RANGE.AND.VALUE<1> = R.NEW(REDO.FC.PRODUCT)
  CALL REDO.FC.NOFILE.CHARGES.DIS(RESP)
  TOT.PRIMAS.PROD = DCOUNT(RESP,FM)

  Z = 1
  LOOP
  WHILE Z LE TOT.PRIMAS.PROD
    LIST.PROP<-1> = FIELD(RESP<Z>,'*',1)
    Z+=1
  REPEAT



  RETURN

* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
*

  GOSUB CHECK.DIS.AMT
  GOSUB CHECK.CHRG.AMT


  RETURN
*
*======================:
CHECK.DIS.AMT:
*======================:

  Y.I = 1
  LOOP
  WHILE Y.I LE Y.NUM.DIS.TYPE
    IF Y.DIS.TYP<1,Y.I> NE "" AND ( Y.DIS.AMT<1,Y.I> EQ "" OR Y.DIS.AMT<1,Y.I> EQ 0 ) THEN
      AF = REDO.FC.DIS.AMT
      AV = Y.I
      GOSUB THROW.ERROR
    END
    IF Y.DIS.TYP<1,Y.I> EQ "" AND Y.DIS.AMT<1,Y.I> NE "" THEN
      AF = REDO.FC.DIS.TYPE
      AV = Y.I
      GOSUB THROW.ERROR
    END
    Y.I+=1
  REPEAT

  RETURN
*======================:
CHECK.CHRG.AMT:
*======================:

  Y.I = 1
  LOOP
  WHILE Y.I LE Y.NUM.DIS.TYPE
    IF Y.CHARG.DISC<1,Y.I> EQ "" AND Y.DIS.CHARG<1,Y.I> NE ""  THEN
      AF = REDO.FC.CHARG.DISC
      AV = Y.I
      GOSUB THROW.ERROR
    END
    IF Y.CHARG.DISC<1,Y.I> NE ""  AND ( Y.DIS.CHARG<1,Y.I> EQ "" OR Y.DIS.CHARG<1,Y.I> EQ 0 ) THEN
      AF = REDO.FC.CHARG.AMOUNT
      AV = Y.I
      GOSUB THROW.ERROR
    END
    Y.I+=1
  REPEAT



  RETURN

*======================:
THROW.ERROR:
*======================:
  PROCESS.GOAHEAD = ""
  ETEXT  = 'EB-FC-MANDOTORY.FIELD'
  CALL STORE.END.ERROR


  RETURN
END
