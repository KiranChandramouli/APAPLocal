*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE  REDO.VI.VISA.CPY.REQ
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.VI.VISA.CPY.REQ
*Date              : 13.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --N/A--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*13/12/2010      saktharrasool@temenos.com   ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.VISA.OUTGOING
$INSERT I_F.REDO.VISA.TC52.FILE


  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN


*------------------------------------------------------------------------------------
OPEN.FILES:
*------------------------------------------------------------------------------------

  FN.REDO.VISA.OUTGOING='F.REDO.VISA.OUTGOING'
  F.REDO.VISA.OUTGOING=''
  CALL OPF(FN.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING)

  RETURN

*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------

  Y.DATA = ""
  CALL BUILD.USER.VARIABLES(Y.DATA)

  Y.ID=FIELD(Y.DATA,"*",2)

  CALL F.READ(FN.REDO.VISA.OUTGOING,Y.ID,R.REDO.VISA.OUTGOING,F.REDO.VISA.OUTGOING,VISA.ERR)
  IF R.REDO.VISA.OUTGOING THEN
    R.NEW(VSA.TC52.TRANSACTION.CODE)=52
    R.NEW(VSA.TC52.TXN.CODE.QUALIFIER)=0
    R.NEW(VSA.TC52.TXN.COMP.SEQ.1)=0
    R.NEW(VSA.TC52.ACCOUNT.NUMBER)=R.REDO.VISA.OUTGOING<VISA.OUT.ACCOUNT.NUMBER>
    R.NEW(VSA.TC52.ACCT.NUM.EXT)=R.REDO.VISA.OUTGOING<VISA.OUT.ACCT.NUM.EXT>
    R.NEW(VSA.TC52.ACQR.REF.NUM)=R.REDO.VISA.OUTGOING<VISA.OUT.ACQR.REF.NUM>
    R.NEW(VSA.TC52.ACQR.BUS.ID)=R.REDO.VISA.OUTGOING<VISA.OUT.ACQR.BUS.ID>
    R.NEW(VSA.TC52.PURCHASE.DATE)=R.REDO.VISA.OUTGOING<VISA.OUT.PURCHASE.DATE>
    R.NEW(VSA.TC52.TRANS.AMT)=R.REDO.VISA.OUTGOING<VISA.OUT.DEST.AMT>
    R.NEW(VSA.TC52.TRANS.CCY.CODE)=R.REDO.VISA.OUTGOING<VISA.OUT.DEST.CCY.CODE>
    R.NEW(VSA.TC52.MERCHANT.NAME)=R.REDO.VISA.OUTGOING<VISA.OUT.MERCHANT.NAME>
    R.NEW(VSA.TC52.MERCHANT.CITY)=R.REDO.VISA.OUTGOING<VISA.OUT.MERCHANT.CITY>
    R.NEW(VSA.TC52.MERCH.CONTRY.CDE)=R.REDO.VISA.OUTGOING<VISA.OUT.MERCH.CONTRY.CDE>
    R.NEW(VSA.TC52.MERCH.CATEG.CDE)=R.REDO.VISA.OUTGOING<VISA.OUT.MERCH.CATEG.CDE>
    R.NEW(VSA.TC52.US.MERCH.ZIP.CD)=R.REDO.VISA.OUTGOING<VISA.OUT.MERCH.ZIP.CDE>
    R.NEW(VSA.TC52.MERCH.STATE)=R.REDO.VISA.OUTGOING<VISA.OUT.MERCH.STATE>
    R.NEW(VSA.TC52.ISS.CON.NO)=''       ;*Issuer Control Number for visa outgoing
    R.NEW(VSA.TC52.REQ.RSN.CD)=R.REDO.VISA.OUTGOING<VISA.OUT.REASON.CODE>
    R.NEW(VSA.TC52.STMT.FLAG)=R.REDO.VISA.OUTGOING<VISA.OUT.STLMT.FLAG>
    R.NEW(VSA.TC52.NAT.REIM.FEE)=0
    R.NEW(VSA.TC52.ACC.SELECTION)=''
    R.NEW(VSA.TC52.RET.REQ.ID)=0
    R.NEW(VSA.TC52.CN.PR.DATE)=R.REDO.VISA.OUTGOING<VISA.OUT.CENTRL.PROCES.DATE>
    R.NEW(VSA.TC52.REIM.ATT)=0
    R.NEW(VSA.TC52.TXN.COMP.SEQ.2)=1
    R.NEW(VSA.TC52.FAX.NO)='' ;*User input.If blank, fill with blank space
    R.NEW(VSA.TC52.INTR.TR.NO)=0
    R.NEW(VSA.TC52.REQ.FULL.MTH)=1
    R.NEW(VSA.TC52.EST.FULL.MTH)=1
    R.NEW(VSA.TC52.ISS.RFC.BIN)=''
    R.NEW(VSA.TC52.ISS.RFC.SUB.AD)=0
    R.NEW(VSA.TC52.ISS.BIL.CCY.CD)=0
    R.NEW(VSA.TC52.ISS.BIL.TR.AMT)=0
    R.NEW(VSA.TC52.TRAN.ID)=0
    R.NEW(VSA.TC52.EX.TRA.ID.RSN)=''
    R.NEW(VSA.TC52.CRS.PROC.CODE)=''
    R.NEW(VSA.TC52.MUL.CLR.SEQ.NO)=0
    R.NEW(VSA.TC52.STATUS)='PENDING'
  END
  RETURN
END
