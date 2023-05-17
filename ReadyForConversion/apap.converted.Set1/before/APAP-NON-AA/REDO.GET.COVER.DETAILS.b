*-----------------------------------------------------------------------------
* <Rating>40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.GET.COVER.DETAILS(Y.FINAL.ARR)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.COVER.DETAILS
* ODR NUMBER    : ODR-2009-10-0795
*--------------------------------------------------------------------------------------------------
* Description   : This routine is used in deal slip for the pupose of delivery of cheque form
* In parameter  : none
* out parameter : Y.FINAL.ARR
*--------------------------------------------------------------------------------------------------
* Modification History :
*--------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 14-01-2011      MARIMUTHU s     ODR-2009-10-0795  Initial Creation
* 05-08-2011      MARIMUTHU S     PACS00099482
*--------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.ADMIN.CHEQUE.DETAILS
$INSERT I_F.AZ.ACCOUNT
$INSERT I_System
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.TEMP.UPDATE.CUS.AC
*-----------------------------------------------------------------------------
MAIN:
*-----------------------------------------------------------------------------
  GOSUB OPENFILES
  GOSUB PROCESS
  GOSUB PROGRAM.END
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
OPENFILES:
*-----------------------------------------------------------------------------
  FN.REDO.ADMIN.CHEQUE.DETAILS = 'F.REDO.ADMIN.CHEQUE.DETAILS'
  F.REDO.ADMIN.CHEQUE.DETAILS = ''
  CALL OPF(FN.REDO.ADMIN.CHEQUE.DETAILS,F.REDO.ADMIN.CHEQUE.DETAILS)

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)

  FN.REDO.TEMP.UPDATE.CUS.AC = 'F.REDO.TEMP.UPDATE.CUS.AC'
  F.REDO.TEMP.UPDATE.CUS.AC = ''
  CALL OPF(FN.REDO.TEMP.UPDATE.CUS.AC,F.REDO.TEMP.UPDATE.CUS.AC)

  RETURN
*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------
  Y.ORDER.CUS = R.NEW(FT.ORDERING.CUST)
  CALL F.READ(FN.REDO.TEMP.UPDATE.CUS.AC,Y.ORDER.CUS,R.TEMP.REC,F.REDO.TEMP.UPDATE.CUS.AC,ERR.TEMP)
  Y.AC.IDS = R.TEMP.REC<REDO.RG.AC.ID>
  Y.AC.DATE = R.TEMP.REC<REDO.RG.AC.DATE>
  Y.SAME.CUST = R.TEMP.REC<REDO.RG.SAME.CUST>
  Y.CNT = DCOUNT(Y.AC.IDS,VM)

  E.BACK = E
  Y.CURRENT.DEPNO = System.getVariable("CURRENT.ALL.ACC")
  CHANGE " " TO VM IN Y.CURRENT.DEPNO
  IF Y.CURRENT.DEPNO EQ "CURRENT.ALL.ACC" THEN
    LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
      E = E.BACK
    END
    Y.CURRENT.DEPNO = ''
  END


  FLAG = ''
  LOOP
  WHILE Y.CNT GT 0 DO
    FLAG += 1

    Y.MAIN.ID = Y.AC.IDS<1,FLAG>:'-':Y.AC.DATE<1,FLAG>
    Y.AC.CHK = Y.AC.IDS<1,FLAG>

    LOCATE Y.AC.CHK IN Y.CURRENT.DEPNO<1,1> SETTING Y.DEP.POS THEN
      CALL F.READ(FN.REDO.ADMIN.CHEQUE.DETAILS,Y.MAIN.ID,R.REDO.ADMIN.CQ.DET,F.REDO.ADMIN.CHEQUE.DETAILS,MA.TEM.ER)
      Y.AC = R.REDO.ADMIN.CQ.DET<REDO.AD.CHQ.DEPOSIT.NO>
      CALL F.READ(FN.AZ.ACCOUNT,Y.AC,R.AZ.ACCOUNT,F.AZ.ACCOUNT,AZ.AC.ERR)

      IF Y.AC NE Y.DUP.AC THEN
        IF FLAG NE 1 THEN
          GOSUB SUB.PROCES.GET.VL
        END ELSE
          GOSUB SUB.PROCESS.VALS2
        END

      END ELSE
        Y.DUP.INT.AMT = Y.DUP.INT.AMT + R.REDO.ADMIN.CQ.DET<REDO.AD.CHQ.INT.PAYMNT.AMT>
        Y.DUP.AC = Y.AC
      END
    END
    Y.CNT -= 1
  REPEAT
  Y.FINAL.ARR := SPACE(18):FMT(Y.DUP.AC,'R#18'):FMT(Y.CREATE.DATE,"R#16"):FMT(Y.CERT.AMT,'R2,#27'):FMT(Y.INT.RATE,'R2,#21'):FMT(Y.DUP.INT.AMT,'R2,#17')

  Y.FINAL.ARR := VM:SPACE(18):'--------------------------------------------------------------------------------------------------------'

  Y.TOT.PRINC = Y.TOT.PRINC + Y.DUP.CERT.AMT
  Y.TOT.INT = Y.TOT.INT + Y.DUP.INT.AMT
  Y.FINAL.ARR := VM:SPACE(18):FMT('TOTAL','L#40'):FMT(Y.TOT.PRINC,'R2,#21'):FMT(Y.TOT.INT,'R2,#38')
  Y.FINAL.ARR := VM:SPACE(18):'--------------------------------------------------------------------------------------------------------'

  RETURN

SUB.PROCES.GET.VL:

  Y.FINAL.ARR := SPACE(18):FMT(Y.DUP.AC,'R#18'):Y.CREATE.DATE:Y.CERT.AMT:Y.INT.RATE:FMT(Y.DUP.INT.AMT,'R2,#17'):VM
  Y.TOT.INT = Y.TOT.INT + Y.DUP.INT.AMT
  Y.TOT.PRINC = Y.TOT.PRINC + Y.DUP.CERT.AMT

  Y.CREATE.DATE = R.AZ.ACCOUNT<AZ.CREATE.DATE>
  Y.CREATE.DATE = ICONV(Y.CREATE.DATE,'D')
  Y.CREATE.DATE = OCONV(Y.CREATE.DATE,'D')
  Y.CREATE.DATE = FMT(Y.CREATE.DATE,'R#16')
  Y.CERT.AMT = R.AZ.ACCOUNT<AZ.PRINCIPAL>
  Y.DUP.CERT.AMT = Y.CERT.AMT
  Y.CERT.AMT = FMT(Y.CERT.AMT,'R2,#27')
  Y.INT.RATE = R.REDO.ADMIN.CQ.DET<REDO.AD.CHQ.INTEREST.RATE>
  Y.INT.RATE = FMT(Y.INT.RATE,'L3%10')
  Y.INT.RATE.1 = FIELD(Y.INT.RATE,'.',1)
  Y.INT.RATE.2 = FIELD(Y.INT.RATE,'.',2)
  Y.INT.RATE.2 = Y.INT.RATE.2[1,3]
  Y.INT.RATE = Y.INT.RATE.1:'.':Y.INT.RATE.2
  Y.INT.RATE = FMT(Y.INT.RATE,'R#21')
  Y.INT.AMT = R.REDO.ADMIN.CQ.DET<REDO.AD.CHQ.INT.PAYMNT.AMT>
  Y.DUP.INT.AMT = Y.INT.AMT
  Y.INT.AMT = FMT(Y.INT.AMT,'L2,#20')
  Y.DUP.AC = Y.AC

  RETURN
SUB.PROCESS.VALS2:

  Y.CREATE.DATE = R.AZ.ACCOUNT<AZ.CREATE.DATE>
  Y.CREATE.DATE = ICONV(Y.CREATE.DATE,'D')
  Y.CREATE.DATE = OCONV(Y.CREATE.DATE,'D')
  Y.CREATE.DATE = FMT(Y.CREATE.DATE,'R#16')
  Y.CERT.AMT = R.AZ.ACCOUNT<AZ.PRINCIPAL>
  Y.DUP.CERT.AMT = Y.CERT.AMT
  Y.CERT.AMT = FMT(Y.CERT.AMT,'R2,#27')
  Y.INT.RATE = R.REDO.ADMIN.CQ.DET<REDO.AD.CHQ.INTEREST.RATE>
  Y.INT.RATE = FMT(Y.INT.RATE,'L3%10')
  Y.INT.RATE.1 = FIELD(Y.INT.RATE,'.',1)
  Y.INT.RATE.2 = FIELD(Y.INT.RATE,'.',2)
  Y.INT.RATE.2 = Y.INT.RATE.2[1,3]
  Y.INT.RATE = Y.INT.RATE.1:'.':Y.INT.RATE.2
  Y.INT.RATE = FMT(Y.INT.RATE,'R#21')
  Y.INT.AMT = R.REDO.ADMIN.CQ.DET<REDO.AD.CHQ.INT.PAYMNT.AMT>
  Y.DUP.INT.AMT = Y.INT.AMT
  Y.INT.AMT = FMT(Y.INT.AMT,'R2,#20')
  Y.DUP.AC = Y.AC

  RETURN
*-----------------------------------------------------------------------------
PROGRAM.END:

END
