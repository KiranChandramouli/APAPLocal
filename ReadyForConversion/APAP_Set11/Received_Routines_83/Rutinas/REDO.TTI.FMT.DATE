*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TTI.FMT.DATE(Y.FIELD.NAME)
*-------------------------------------------------------------
*Description: This routine is call routine from deal slip of TT...

*-------------------------------------------------------------
*Input Arg : Y.INP.DEAL
*Out Arg   : Y.INP.DEAL
*Deals With: TT payement
*Modify    :btorresalbornoz
*-------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY
$INSERT I_F.TELLER.ID
$INSERT I_F.CURRENCY
$INSERT I_System


  GOSUB PROCESS

  RETURN

*----------------------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------------------

  FN.CURRENCY = 'F.CURRENCY'
  F.CURRENCY = ''
  CALL OPF(FN.CURRENCY,F.CURRENCY)
  Y.CURRENCY = R.NEW(TT.TID.CURRENCY)
  Y.CURRENCY =  CHANGE(Y.CURRENCY,SM,VM)
  Y.CURRENCY =  CHANGE(Y.CURRENCY,FM,VM)

  BEGIN CASE

  CASE Y.FIELD.NAME EQ 'Y.CCY'

    CALL F.READ(FN.CURRENCY,Y.CURRENCY<1,1>,R.CURRENCY,F.CURRENCY,Y.ERR)
    Y.CURRENCY.1=R.CURRENCY<EB.CUR.CCY.NAME>
    IF Y.CURRENCY<1,1> = 'DOP' THEN
      Y.CURRENCY.1="RD$(":Y.CURRENCY.1:")"
      Y.FIELD.NAME=FMT(Y.CURRENCY.1,"22R")
    END ELSE
      Y.FIELD.NAME=FMT(Y.CURRENCY.1,"22R")
    END

    RETURN



  CASE Y.FIELD.NAME EQ 'Y.CCY2'

    CALL F.READ(FN.CURRENCY,Y.CURRENCY<1,2>,R.CURRENCY,F.CURRENCY,Y.ERR)
    Y.CURRENCY.2=R.CURRENCY<EB.CUR.CCY.NAME>
    IF Y.CURRENCY<1,2> = 'DOP' THEN
      Y.CURRENCY.2="RD$(":Y.CURRENCY.2:")"
      Y.FIELD.NAME=FMT(Y.CURRENCY.2,"22R")
    END ELSE
      Y.FIELD.NAME=FMT(Y.CURRENCY.2,"22R")
    END

    RETURN




  CASE Y.FIELD.NAME EQ 'Y.OVERRIDE.1'
    GOSUB OVERRIDE1


    RETURN

  CASE Y.FIELD.NAME EQ 'Y.OVERRIDE.2'







    GOSUB OVERRIDE2

    RETURN

  CASE Y.FIELD.NAME EQ 'Y.DATE.TIME'
    GET.DATE.TIME = R.NEW(TT.TID.DATE.TIME)
    GOSUB GET.DATE.TIME.INFO

    RETURN

  END CASE

  GOSUB SEND.PROCESS

  RETURN
*-------------------------------------------------------------------------
SEND.PROCESS:
*-------------------------------------------------------------------------

  BEGIN CASE

  CASE Y.FIELD.NAME EQ 'Y.CO.CODE'
    Y.TELLER.NAME = R.NEW(TT.TID.USER)
    Y.TELLER.NAME=Y.TELLER.NAME[1,7]
    GET.CO.CODE ='APAP':" ":R.COMPANY(EB.COM.COMPANY.NAME):"-":Y.TELLER.NAME
    Y.FIELD.NAME = FMT(GET.CO.CODE,"30R")

    RETURN

  CASE Y.FIELD.NAME EQ 'Y.STMT.NO'
    Y.TELLER.ID2=ID.NEW
    FN.TELLER.ID = 'F.TELLER.ID'
    F.TELLER.ID = ''
    CALL OPF(FN.TELLER.ID,F.TELLER.ID)
    CALL F.READ(FN.TELLER.ID,Y.TELLER.ID2,R.TELLER.ID,F.TELLER.ID,I.ERR)
    Y.STMT.NO=R.TELLER.ID<TT.TID.STMT.NO>
    Y.STMT.NO= CHANGE(Y.STMT.NO,SM,VM)
    Y.STMT.NO= CHANGE(Y.STMT.NO,FM,VM)
    Y.STMT.NO= Y.STMT.NO<1,1>
    Y.STMT.NO=Y.STMT.NO[1,34]
    Y.FIELD.NAME  = FMT(Y.STMT.NO,"34R")

    RETURN


  END CASE

  RETURN
*-----------------------------------------------
OVERRIDE2:
*-----------------------------------------------
  Y.OVERRIDE.2 = R.NEW(TT.TID.OVERRIDE)
  Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,SM,VM)
  Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,FM,VM)
  Y.OVERRIDE.2 = Y.OVERRIDE.2<1,2>
  Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,'{',FM)
  Y.OVERRIDE.2 = CHANGE(Y.OVERRIDE.2,'}',VM)
  CALL TXT(Y.OVERRIDE.2)
  Y.OVERRIDE.2 = Y.OVERRIDE.2[1,34]
  Y.FIELD.NAME  = FMT(Y.OVERRIDE.2,"34R")
  RETURN

*-----------------------------------------------
OVERRIDE1:
*-----------------------------------------------

  Y.OVERRIDE.1 = R.NEW(TT.TID.OVERRIDE)
  Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,SM,VM)
  Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,FM,VM)
  Y.OVERRIDE.1 = Y.OVERRIDE.1<1,1>
  Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,'{',FM)
  Y.OVERRIDE.1 = CHANGE(Y.OVERRIDE.1,'}',VM)
  CALL TXT(Y.OVERRIDE.1)
  Y.OVERRIDE.1 = Y.OVERRIDE.1[1,34]
  Y.FIELD.NAME  = FMT(Y.OVERRIDE.1,"34R")
  RETURN
*-----------------------------------------------
GET.DATE.TIME.INFO:
*-----------------------------------------------

  F1 = GET.DATE.TIME[1,2]
  F2 = GET.DATE.TIME[3,2]
  F3 = GET.DATE.TIME[5,2]
  F4 = GET.DATE.TIME[7,2]
  F5 = GET.DATE.TIME[9,2]

  Y.TIME = F3:'/':F2:'/':F1:'-':F4:':':F5
  Y.FIELD.NAME = FMT(Y.TIME,"15R")

  RETURN


END
