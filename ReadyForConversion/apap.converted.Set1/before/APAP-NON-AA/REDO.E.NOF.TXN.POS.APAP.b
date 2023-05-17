*--------------------------------------------------------------------------------
* <Rating>-102</Rating>
*--------------------------------------------------------------------------------
  SUBROUTINE REDO.E.NOF.TXN.POS.APAP(Y.FINAL.ARRAY)
*--------------------------------------------------------------------------------
* Company   Name    : Asociacion Popular de Ahorros y Prestamos
* Developed By      : Ramkumer G
* Program   Name    : REDO.E.NOF.TXN.POS.APAP
* Reference         : ODR-2010-03-0185
*---------------------------------------------------------------------------------
* DESCRIPTION      : This is a nofile enquiry routine which selects the FTTC ids from
*                    the flat file REDO.VISA.FT.LOG which in turn already updated by
*                    a batch routine REDO.VISA.ACQUIRER.TXN
*---------------------------------------------------------------------------------
* Attached to      : Attached to the standard selection NOFILE.TXN.POS.APAP
* In Parameter     : -N/A-
* Out Parameter    : Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
* Modification History:
*----------------------
* 07 Mar 2011       Ramkumar G        ODR-2010-03-0185    INITIAL CREATION
*---------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AC.LOCKED.EVENTS
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.ATM.REVERSAL
$INSERT I_F.REDO.APAP.H.PARAMETER
$INSERT I_F.REDO.CARD.BIN
*---------------------------------------------------------------------------------
  GOSUB INITIALISE
  GOSUB PROCESS
  Y.FINAL.ARRAY<-1> = "******CNT*CNT*CNT**":Y.TOTAL.TXN:"*":Y.APAP.ATM.TXN:"*":Y.OTHER.LOCAL.ATM.TXN:"*":Y.OTHER.INTER.ATM.TXN:"*":Y.TOTAL.ATM.TXN:"*":Y.TOTAL.POS.TXN:"*":Y.APAP.POS.TXN:"*":Y.OTHER.LOCAL.POS.TXN:"*":Y.OTHER.INTER.POS.TXN

  RETURN

*---------------------------------------------------------------------------------
INITIALISE:
*----------
  FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
  F.ATM.REVERSAL = ''
  CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)
*
  FN.APAP.PARAMETER = 'F.REDO.APAP.H.PARAMETER'
  F.APAP.PARAMETER = ''
  CALL OPF(FN.APAP.PARAMETER,F.APAP.PARAMETER)
*
  FN.CARD.BIN = 'F.REDO.CARD.BIN'
  F.CARD.BIN = ''
  CALL OPF(FN.CARD.BIN,F.CARD.BIN)
*
  FN.FT.LOG = 'F.REDO.VISA.FT.LOG'
  F.FT.LOG = ''
  CALL OPF(FN.FT.LOG,F.FT.LOG)
*
  FN.FT = 'F.FUNDS.TRANSFER'
  F.FT = ''
  CALL OPF(FN.FT,F.FT)
*
  FN.AC.LOCKED.EVENTS = 'F.AC.LOCKED.EVENTS'
  F.AC.LOCKED.EVENTS = ''
  CALL OPF(FN.AC.LOCKED.EVENTS,F.AC.LOCKED.EVENTS)

  FN.FT.HIS = 'F.FUNDS.TRANSFER$HIS'
  F.FT.HIS = ''
  CALL OPF(FN.FT.HIS,F.FT.HIS)

*
  Y.TOT.ATM.POS = 0 ; Y.APAP.ATM.TXN = 0 ;  Y.OTHER.LOCAL.ATM.TXN = 0 ;
  Y.OTHER.INTER.ATM.TXN = 0 ; Y.APAP.POS.TXN = 0 ; Y.OTHER.LOCAL.POS.TXN = 0 ;
  Y.OTHER.INTER.POS.TXN = 0 ; Y.TOTAL.ATM.TXN = 0 ; Y.TOTAL.TXN = 0 ;
*
  Y.APPL = 'AC.LOCKED.EVENTS'
  Y.FIELD = 'L.TXN.AMT.LOCAL'
  Y.POS = ''
  CALL MULTI.GET.LOC.REF(Y.APPL,Y.FIELD,Y.POS)
  Y.TXN.AMT.LOCAL.POS = Y.POS<1,1>
*
  RETURN

*---------------------------------------------------------------------------------
PROCESS:
*-------
  SEL.CMD = "SELECT ":FN.FT.LOG:" WITH @ID"
  SEL.LIST = ''
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.RECS,RET.CODE)
  LOOP
    REMOVE Y.FTTC.ID FROM SEL.LIST SETTING Y.FTT.POS
  WHILE Y.FTTC.ID:Y.FTT.POS
    GOSUB BASE.PROCESS
  REPEAT
  RETURN

*----------------------------------------------------------------------------------
BASE.PROCESS:
*------------
  CALL F.READ(FN.FT.LOG,Y.FTTC.ID,R.FT.LOG,F.FT.LOG,Y.LINE.ERROR)
  LOOP
    REMOVE Y.ATM.FT.ID FROM R.FT.LOG SETTING Y.LINE.POS
  WHILE Y.ATM.FT.ID:Y.LINE.POS
    GOSUB ATM.PROCESS
  REPEAT
  RETURN

*----------------------------------------------------------------------------------
ATM.PROCESS:
*-----------
  Y.ATM.REV.ID = FIELD(Y.ATM.FT.ID,'*',2)
*SEL.CMD.TEST = 'SELECT ':FN.ATM.REVERSAL
*CALL EB.READLIST(SEL.CMD.TEST,SEL.CMD.TST.LIST,'',NO.OF.REC.TST,ERR.RST)
*LOOP
*    REMOVE Y.ATM.REV.ID FROM SEL.CMD.TST.LIST SETTING POS.TST
*WHILE Y.ATM.REV.ID:POS.TST
  IF Y.ATM.REV.ID THEN
    Y.TEST.ATM.ID<-1> = Y.ATM.REV.ID
    CALL F.READ(FN.ATM.REVERSAL,Y.ATM.REV.ID,R.ATM.REVERSAL,F.ATM.REVERSAL,YATM.ERR)
    GOSUB FETCH.DETAILS
    GOSUB BIN.CLASSIFY
    GOSUB TOTAL.PROCESS
    GOSUB FINAL.ARRAY
  END
*REPEAT
  RETURN

*-----------------------------------------------------------------------------------
FETCH.DETAILS:
*-------------
  Y.TERM.NO = R.ATM.REVERSAL<AT.REV.TERM.ID>
  Y.ACCT.NO = R.ATM.REVERSAL<AT.REV.CARD.NUMBER>
  Y.TXN.TYPE = R.ATM.REVERSAL<AT.REV.PROCESS.CODE>
  Y.AUTH.NO = R.ATM.REVERSAL<AT.REV.TRACE>
  Y.TXN.DATE = R.ATM.REVERSAL<AT.REV.LOCAL.DATE>
  Y.TXN.DATE = TODAY[1,4]:Y.TXN.DATE
  Y.TXN.DATE = ICONV(Y.TXN.DATE,'D')
  Y.TXN.DATE = OCONV(Y.TXN.DATE,'D')
  Y.TXN.DATE = Y.TXN.DATE[1,6]
  Y.TIME = R.ATM.REVERSAL<AT.REV.LOCAL.TIME>
  Y.TIME = Y.TIME[1,2]:':':Y.TIME[3,2]:':':Y.TIME[5,2]
  Y.AUTH.AMT = R.ATM.REVERSAL<AT.REV.TRANSACTION.AMOUNT> - 0
  Y.TXN.REF = R.ATM.REVERSAL<AT.REV.TXN.REF>
  IF Y.TXN.REF[1,4] EQ 'ACLK' THEN
    CALL F.READ(FN.AC.LOCKED.EVENTS,Y.TXN.REF,R.ACLK,F.AC.LOCKED.EVENTS,Y.ACLK.ERR)
    Y.COMM =  R.ACLK<AC.LCK.LOCAL.REF,Y.TXN.AMT.LOCAL.POS>
    IF Y.COMM[1,3] EQ 'DOP' THEN
      Y.COMM = Y.COMM[4,-1]
    END

  END ELSE
    CALL F.READ(FN.FT,Y.TXN.REF,R.FT,F.FT,Y.FT.ERR)
    IF R.FT EQ '' THEN
      CALL EB.READ.HISTORY.REC(F.FT.HIS,Y.TXN.REF,R.FT,HIS.FT.ERR)
    END
    Y.COMM = R.FT<FT.COMMISSION.AMT>
    IF Y.COMM[1,3] EQ 'DOP' THEN
      Y.COMM = Y.COMM[4,-1]
    END
  END
  Y.COMM.AFF = R.ATM.REVERSAL<AT.REV.AFL.CHRG>
  Y.ENTRY.DATE = R.ATM.REVERSAL<AT.REV.TXN.DATE>
  Y.ENTRY.DATE = ICONV(Y.ENTRY.DATE,'D')
  Y.ENTRY.DATE = OCONV(Y.ENTRY.DATE,'D')
  Y.SOURCE.ATM = R.ATM.REVERSAL<AT.REV.TXN.SOURCE>
  FINDSTR 'ATM' IN Y.SOURCE.ATM SETTING POS.AIN THEN
    Y.SOURCE.VAL = 'ATM'
  END
  FINDSTR 'POS' IN Y.SOURCE.ATM SETTING POS.AIN.1 THEN
    Y.SOURCE.VAL = 'POS'
  END

  RETURN

*------------------------------------------------------------------------------------
BIN.CLASSIFY:
*------------
  Y.BIN.ID = Y.ATM.REV.ID[1,6]
  CALL F.READ(FN.CARD.BIN,Y.BIN.ID,R.CARD.BIN,F.CARD.BIN,Y.BIN.ERR)
  Y.BIN.TYPE = R.CARD.BIN<REDO.CARD.BIN.BIN.TYPE>
  Y.NATIONAL.MARK = R.CARD.BIN<REDO.CARD.BIN.NATIONAL.MARK>
  Y.BIN.OWNER = R.CARD.BIN<REDO.CARD.BIN.BIN.OWNER>

  IF Y.BIN.OWNER EQ "APAP" AND Y.NATIONAL.MARK EQ "YES" THEN
    IF Y.SOURCE.VAL EQ 'ATM' THEN
      Y.APAP.ATM.TXN = Y.APAP.ATM.TXN + 1
    END
    IF Y.SOURCE.VAL EQ 'POS' THEN
      Y.APAP.POS.TXN = Y.APAP.POS.TXN + 1
    END
  END  ELSE
* IF Y.BIN.OWNER EQ "NON.APAP" AND Y.NATIONAL.MARK EQ "YES" THEN
    IF Y.SOURCE.VAL EQ 'ATM' THEN
      Y.OTHER.LOCAL.ATM.TXN = Y.OTHER.LOCAL.ATM.TXN + 1
    END
    IF Y.SOURCE.VAL EQ 'POS' THEN
      Y.OTHER.LOCAL.POS.TXN = Y.OTHER.LOCAL.POS.TXN + 1
    END
  END
* IF Y.BIN.OWNER EQ "NON.APAP" AND Y.NATIONAL.MARK EQ "NO" THEN
*     IF Y.SOURCE.VAL EQ 'ATM' THEN
*         Y.OTHER.INTER.ATM.TXN = Y.OTHER.INTER.ATM.TXN + 1
*     END
*     IF Y.SOURCE.VAL EQ 'POS' THEN
*         Y.OTHER.INTER.POS.TXN = Y.OTHER.INTER.POS.TXN + 1
*     END
* END
  RETURN

*--------------------------------------------------------------------------------------
TOTAL.PROCESS:
*-------------
  Y.TOTAL.ATM.TXN = Y.APAP.ATM.TXN + Y.OTHER.LOCAL.ATM.TXN + Y.OTHER.INTER.ATM.TXN
  Y.TOTAL.POS.TXN = Y.APAP.POS.TXN + Y.OTHER.LOCAL.POS.TXN + Y.OTHER.INTER.POS.TXN
  Y.TOTAL.TXN = Y.TOTAL.ATM.TXN + Y.TOTAL.POS.TXN
  RETURN

*--------------------------------------------------------------------------------------
FINAL.ARRAY:
*-----------
  IF Y.FINAL.ARRAY THEN
    Y.FINAL.ARRAY<-1> = Y.TERM.NO:"*":Y.ACCT.NO:"*":Y.TXN.TYPE:"*":Y.AUTH.NO:"*":Y.TXN.DATE:"*":Y.TIME:"*":Y.AUTH.AMT:"*":Y.COMM:"*":Y.COMM.AFF:"*":Y.ENTRY.DATE
*                               1               2            3              4            5             6             7            8          9               10                11                 12                          13                     14                  15                          16                        17                18               19
  END ELSE
    Y.FINAL.ARRAY = Y.TERM.NO:"*":Y.ACCT.NO:"*":Y.TXN.TYPE:"*":Y.AUTH.NO:"*":Y.TXN.DATE:"*":Y.TIME:"*":Y.AUTH.AMT:"*":Y.COMM:"*":Y.COMM.AFF:"*":Y.ENTRY.DATE
*                           1              2            3              4            5             6             7            8          9               10                11                 12                          13                     14                  15                          16                        17                18               19
  END
  Y.SOURCE.VAL = ''
  Y.TERM.NO = ''; Y.ACCT.NO = ''; Y.TXN.TYPE = ''; Y.AUTH.NO = ''; Y.TXN.DATE = ''; Y.TIME = '';Y.AUTH.AMT = ''; Y.COMM = '';Y.COMM.AFF = '';Y.ENTRY.DATE = ''
  RETURN
END
