*-----------------------------------------------------------------------------
* <Rating>-82</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.GEN.NCF.UNMAP(TXN.CODE.STMT.REF)
*--------------------------------------------------------------------------------
*-----------------------------------------------------------------------------
*DESCRIPTION:
*------------
*This Routine will generate REDO.L.NCF.UNMAPPED RECORD for all COB generated
*charges and taxes
* Input/Output:
*--------------
* IN  : TXN.CODE.STMT.REF
* OUT : -NA-
*
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-
*
* Revision History:
*------------------
*   Date               who           Reference            Description
* 25-MAR-2010       Prabhu.N       ODR-2009-10-0321    Initial Creation
*--------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.STMT.ENTRY
$INSERT I_F.CATEG.ENTRY
$INSERT I_F.TRANSACTION
$INSERT I_F.TRANSACTION.CHARGE
$INSERT I_F.TAX
$INSERT I_F.REDO.L.NCF.UNMAPPED
$INSERT I_F.REDO.L.NCF.STATUS
$INSERT I_REDO.B.GEN.NCF.UNMAP.COMMON
  GOSUB INIT
  RETURN
*----
INIT:
*----

  TXN.CODE.STMT.REF=CHANGE(TXN.CODE.STMT.REF,"*",SM)
  TXN.CODE.STMT.REF=CHANGE(TXN.CODE.STMT.REF,"+",VM)
  VAR.TRANS.CODE=TXN.CODE.STMT.REF<1,1,1>
  VAR.CUSTOMER=TXN.CODE.STMT.REF<1,1,2>
  Y.CATEG.LIST=TXN.CODE.STMT.REF<1,2>
  CHANGE SM TO FM IN Y.CATEG.LIST
  LOOP
    REMOVE Y.CATEG.ID FROM Y.CATEG.LIST SETTING CATEG.POS
  WHILE Y.CATEG.ID:CATEG.POS
    CALL F.READ(FN.CATEG.ENTRY,Y.CATEG.ID,R.CATEG.ENTRY,F.CATEG.ENTRY,CATEG.ERROR)
    GOSUB GET.TAX.CATEGORY
    Y.STMT.ENT.ID             =Y.CATEG.ID
    CALL F.READ(FN.STMT.ENTRY,Y.STMT.ENT.ID,R.STMT.ENTRY,F.STMT.ENTRY,STMT.ERROR)
    VAR.TRANS.REF =R.CATEG.ENTRY<AC.CAT.TRANS.REFERENCE>
    SEL.CMD.ISSUED="SELECT ":FN.REDO.NCF.ISSUED:" WITH TXN.ID EQ ": VAR.TRANS.REF
    SEL.CMD.UNMAP ="SELECT ":FN.NCF.UNMAPPED:" WITH TXN.ID EQ ": VAR.TRANS.REF :" AND BATCH NE YES"
    SEL.CMD.CATEG.TAX="SELECT ":FN.CATEG.ENTRY:" WITH TRANS.REFERENCE EQ ":VAR.TRANS.REF:" PL.CATEGORY EQ ":VAR.CATEGORY
    CALL EB.READLIST(SEL.CMD.ISSUED,SEL.ISSUED.LIST,'',NO.OF.IS.REC,IS.ERR)
    CALL EB.READLIST(SEL.CMD.UNMAP,SEL.UNMAP.LIST,'',NO.OF.UM.REC,UM.ERR)
    IF SEL.ISSUED.LIST EQ '' AND SEL.UNMAP.LIST EQ '' THEN
      GOSUB PROCESS
    END
  REPEAT
  GOSUB PROCESS.NCF
  RETURN
*-------
PROCESS:
*-------
  VAR.ACCT.NO=R.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>
  IF VAR.ACCOUNT.LIST EQ '' THEN
    GOSUB ARR.START.PROCESS
  END
  ELSE
    LOCATE VAR.ACCT.NO IN VAR.ACCOUNT.LIST SETTING ACCT.POS THEN
      GOSUB LIST.PROCESS
    END
    ELSE
      GOSUB ARR.START.PROCESS
    END
  END
  RETURN
*------------------
ARR.START.PROCESS:
*-------------------
  VAR.ACCOUNT.LIST<-1>  =R.STMT.ENTRY<AC.STE.ACCOUNT.NUMBER>
  VAR.DATE.TIME<-1>     =R.STMT.ENTRY<AC.STE.VALUE.DATE>
  IF  R.STMT.ENTRY<AC.STE.CURRENCY> EQ LCCY THEN
    VAR.CHARGE.AMOUNT<-1> =R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY>
    VAR.TXN.CHARGE<-1>    =R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY>
    VAR.TAX.AMOUNT<-1>    =R.CATEG.TAX<AC.CAT.AMOUNT.LCY>
    VAR.TXN.TAX<-1>       =R.CATEG.TAX<AC.CAT.AMOUNT.LCY>
  END
  ELSE
    VAR.CHARGE.AMOUNT<-1> =R.CATEG.ENTRY<AC.CAT.AMOUNT.FCY>
    VAR.TXN.CHARGE<-1>    =R.CATEG.ENTRY<AC.CAT.AMOUNT.FCY>
    VAR.TAX.AMOUNT<-1>    =R.CATEG.TAX<AC.CAT.AMOUNT.FCY>
    VAR.TXN.TAX<-1>       =R.CATEG.TAX<AC.CAT.AMOUNT.FCY>
  END
  VAR.TXN.ID<-1>        =R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
  VAR.STMT.ID<-1>       =Y.STMT.ENT.ID
  CALL EB.READLIST(SEL.CMD.CATEG.TAX,CATEG.TAX.LIST,'',NO.OF.TAX.REC,TAX.ERR)
  CALL F.READ(FN.CATEG.ENTRY,CATEG.TAX.LIST,R.CATEG.TAX,F.CATEG.ENTRY,ERR.TAX)
  RETURN
*-------------
LIST.PROCESS:
*-------------
  VAR.TXN.ID<ACCT.POS>        =VAR.TXN.ID<ACCT.POS>:VM:R.STMT.ENTRY<AC.STE.TRANS.REFERENCE>
  VAR.STMT.ID<ACCT.POS>       =Y.STMT.ENT.ID
  CALL EB.READLIST(SEL.CMD.CATEG.TAX,CATEG.TAX.LIST,'',NO.OF.TAX.REC,TAX.ERR)
  CALL F.READ(FN.CATEG.ENTRY,CATEG.TAX.LIST,R.CATEG.TAX,F.CATEG.ENTRY,ERR.TAX)
  IF  R.STMT.ENTRY<AC.STE.CURRENCY> EQ LCCY THEN
    VAR.TAX.AMOUNT<ACCT.POS>    =VAR.TAX.AMOUNT<ACCT.POS>+R.CATEG.TAX<AC.CAT.AMOUNT.LCY>
    VAR.TXN.CHARGE<ACCT.POS>    =VAR.TXN.CHARGE<ACCT.POS>:VM:R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY>
    VAR.TXN.TAX<ACCT.POS>       =VAR.TXN.TAX<ACCT.POS>:VM:R.CATEG.TAX<AC.CAT.AMOUNT.LCY>
    VAR.CHARGE.AMOUNT<ACCT.POS> =VAR.CHARGE.AMOUNT<ACCT.POS>+R.CATEG.ENTRY<AC.CAT.AMOUNT.LCY>
  END
  ELSE
    VAR.TAX.AMOUNT<ACCT.POS>    =VAR.TAX.AMOUNT<ACCT.POS>+R.CATEG.TAX<AC.CAT.AMOUNT.FCY>
    VAR.TXN.CHARGE<ACCT.POS>    =VAR.TXN.CHARGE<ACCT.POS>:VM:R.CATEG.ENTRY<AC.CAT.AMOUNT.FCY>
    VAR.TXN.TAX<ACCT.POS>       =VAR.TXN.TAX<ACCT.POS>:VM:R.CATEG.TAX<AC.CAT.AMOUNT.FCY>
    VAR.CHARGE.AMOUNT<ACCT.POS> =VAR.CHARGE.AMOUNT<ACCT.POS>+R.CATEG.ENTRY<AC.CAT.AMOUNT.FCY>
  END
  RETURN
*--------
PROCESS.NCF:
*---------
  LOOP
    REMOVE  ACCOUNT.ID  FROM VAR.ACCOUNT.LIST SETTING ACCT.POSITION
  WHILE ACCOUNT.ID:ACCT.POSITION
    LOCATE ACCOUNT.ID IN VAR.ACCOUNT.LIST SETTING ACCT.LIST.POS THEN
      VAR.LAST.TXN.POS=DCOUNT(VAR.TXN.ID<ACCT.LIST.POS>,VM)
      VAR.LAST.TXN=VAR.TXN.ID<ACCT.LIST.POS,VAR.LAST.TXN.POS>
      GOSUB WRITE.NCF
    END
  REPEAT
  RETURN
*------------
WRITE.NCF:
*------------
  Y.NCF.ID                           =VAR.ACCOUNT.LIST<ACCT.LIST.POS>: '.':TODAY-1:'.':VAR.TRANS.CODE
  R.NCF.UNMAPPED<ST.UN.TXN.TYPE>     =VAR.TRANS.CODE
  R.NCF.UNMAPPED<ST.UN.CHARGE.AMOUNT>=VAR.CHARGE.AMOUNT<ACCT.LIST.POS>
  R.NCF.UNMAPPED<ST.UN.TXN.ID>       =VAR.TXN.ID<ACCT.LIST.POS>
  R.NCF.UNMAPPED<ST.UN.TXN.CHARGE>   =VAR.TXN.CHARGE<ACCT.LIST.POS>
  R.NCF.UNMAPPED<ST.UN.TXN.TAX>      =VAR.TXN.TAX<ACCT.LIST.POS>
  R.NCF.UNMAPPED<ST.UN.TAX.AMOUNT>   =VAR.TAX.AMOUNT<ACCT.LIST.POS>
  R.NCF.UNMAPPED<ST.UN.DATE>         =VAR.DATE.TIME<ACCT.LIST.POS>
  R.NCF.UNMAPPED<ST.UN.CUSTOMER>     =VAR.CUSTOMER
  R.NCF.UNMAPPED<ST.UN.STMT.ID>      =VAR.STMT.ID<ACCT.LIST.POS>
  R.NCF.UNMAPPED<ST.UN.BATCH>        ='YES'
  R.NCF.UNMAPPED<ST.UN.ACCOUNT>      =VAR.ACCOUNT.LIST<ACCT.LIST.POS>
  CALL F.WRITE(FN.NCF.UNMAPPED,Y.NCF.ID,R.NCF.UNMAPPED)
  R.NCF.STATUS<NCF.ST.TRANSACTION.ID>=VAR.TXN.ID<ACCT.LIST.POS>
  R.NCF.STATUS<NCF.ST.CUSTOMER.ID>   =VAR.CUSTOMER
  R.NCF.STATUS<NCF.ST.DATE>          =VAR.DATE.TIME<ACCT.LIST.POS>
  R.NCF.STATUS<NCF.ST.CHARGE.AMOUNT> =VAR.CHARGE.AMOUNT<ACCT.LIST.POS>
  R.NCF.STATUS<NCF.ST.TAX.AMOUNT>    =VAR.TAX.AMOUNT<ACCT.LIST.POS>
  R.NCF.STATUS<NCF.ST.STATUS>        ='UNAVAILABLE'
  CALL F.WRITE(FN.NCF.STATUS,Y.NCF.ID,R.NCF.STATUS)
  RETURN
*---------------
GET.TAX.CATEGORY:
*---------------
  CALL F.READ(FN.TRANSACTION,VAR.TRANS.CODE,R.TRANSACTION,F.TRANSACTION,TR.ERR)
  VAR.TRANS.CHARGE=R.TRANSACTION<AC.TRA.CHARGE.KEY>
  CALL F.READ(FN.TRANSACTION.CHARGE,VAR.TRANS.CHARGE,R.TRANS.CHARGE,F.TRANSACTION.CHARGE,TR.CH.ERR)
  VAR.TAX.ID=R.TRANS.CHARGE<IC.TCH.TAX.CODE>
  CALL F.READ(FN.TAX,VAR.TAX.ID,R.TAX,F.TAX,TAX.ERR)
  VAR.CATEGORY=R.TAX<EB.TAX.CATEGORY>
  RETURN
END
