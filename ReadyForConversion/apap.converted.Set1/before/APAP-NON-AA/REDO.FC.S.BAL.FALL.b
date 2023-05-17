*-----------------------------------------------------------------------------
* <Rating>-94</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.S.BAL.FALL
*=============================================================================
*
* Subroutine Type :
* Attached to     :
* Attached as     :
* Primary Purpose :check if the arrangement has a end balance
*
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Bryan Torres (btorresalbornoz@temenos.com) - TAM Latin America
* Date            : Agosto 25 2011
*------------------------------------------------------------------------------------------------------------------
* Revision History:
* -----------------
*Date          Name              Description
*----          ----              ------------
*2011-12-15    Victor Panchi     PACS00169926

*=======================================================================

*************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.REDO.FC.LIMIT.AA
$INSERT I_F.REDO.FC.CL.BALANCE
$INSERT I_F.REDO.CREATE.ARRANGEMENT
$INSERT I_F.REDO.APP.MAPPING

$INSERT I_F.AA.BILL.DETAILS
$INSERT I_F.COLLATERAL.RIGHT

$INSERT I_F.REDO.FC.PROD.COLL.POLICY
*************************************************************************

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN

* ======
PROCESS:
* ======
  GOSUB GET.COLL.CODE
  GOSUB GET.SD.COLL
  GOSUB GET.LIMIT
  GOSUB GET.ID.ARR

  RETURN

*
*=============
GET.COLL.CODE:
*=============
  Y.PRODUCT = R.NEW(REDO.FC.PRODUCT)
  CALL CACHE.READ(FN.REDO.FC.PROD.COLL.POLICY, Y.PRODUCT, R.REDO.FC.PROD.COLL.POLICY, YERR)
  Y.TYPES.CODES = R.REDO.FC.PROD.COLL.POLICY<REDO.CPL.COLLATERAL.CODE>

  LOCATE "450" IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
    IF YPOS THEN
      IF Y.TYPE.COLL NE '' THEN
        Y.TYPE.COLL := VM:450
        YPOS = ''
      END ELSE
        Y.TYPE.COLL = 450
        YPOS = ''
      END
    END
  END

  LOCATE "350" IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
    IF YPOS THEN
      IF Y.TYPE.COLL NE '' THEN
        Y.TYPE.COLL := VM:350
        YPOS = ''
      END ELSE
        Y.TYPE.COLL = 350
        YPOS = ''
      END
    END
  END

  LOCATE "100" IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
    IF YPOS THEN
      IF Y.TYPE.COLL NE '' THEN
        Y.TYPE.COLL := VM:100
        YPOS = ''
      END ELSE
        Y.TYPE.COLL = 100
        YPOS = ''
      END
    END
  END

  LOCATE "150" IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
    IF YPOS THEN
      IF Y.TYPE.COLL NE '' THEN
        Y.TYPE.COLL := VM:150
        YPOS = ''
      END ELSE
        Y.TYPE.COLL = 150
        YPOS = ''
      END
    END
  END

  LOCATE "200" IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
    IF YPOS THEN
      IF Y.TYPE.COLL NE '' THEN
        Y.TYPE.COLL := VM:200
        YPOS = ''
      END ELSE
        Y.TYPE.COLL = 200
        YPOS = ''
      END
    END
  END

  LOCATE "970" IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
    IF YPOS THEN
      IF Y.TYPE.COLL NE '' THEN
        Y.TYPE.COLL := VM:970
        YPOS = ''
      END ELSE
        Y.TYPE.COLL = 970
        YPOS = ''
      END
    END

  END

  LOCATE "450" IN Y.TYPES.CODES<1,1> SETTING YPOS THEN
    IF YPOS THEN
      IF Y.TYPE.COLL NE '' THEN
        Y.TYPE.COLL := VM:450
        YPOS = ''
      END ELSE
        Y.TYPE.COLL = 450
        YPOS = ''
      END
    END
  END
  RETURN

* ==========
GET.SD.COLL:
* ==========
  Y.COUNT.C.U = DCOUNT(Y.TYPE.COLL,VM)
  FOR Y.C.U = 1 TO Y.COUNT.C.U
    REDO.APP.MAPPING.ID = 'CC-' : Y.TYPE.COLL<1,Y.C.U>
    CALL CACHE.READ(FN.REDO.APP.MAPPING,REDO.APP.MAPPING.ID, R.REDO.APP.MAPPING, Y.ERR)
    IF R.REDO.APP.MAPPING THEN
      Y.MAPP.FILED = R.REDO.APP.MAPPING<REDO.APP.FIELD.TO>
      Y.APLICATION  = FIELD(R.REDO.APP.MAPPING<REDO.APP.APP.FROM>,VM,1)
      LOCATE "@ID" IN Y.MAPP.FILED<1,1> SETTING ZPOS THEN
        Y.NAME.FIELD.ID  = FIELD(R.REDO.APP.MAPPING<REDO.APP.FIELD.FROM>,VM,ZPOS)
      END
      GOSUB GET.SD.COLL.THEN
    END
  NEXT Y.C.U
  RETURN

* ==============
GET.SD.COLL.THEN:
* ==============
  CALL EB.FIND.FIELD.NO(Y.APLICATION, Y.NAME.FIELD.ID)
  Y.COLL.ID  =  R.NEW(Y.NAME.FIELD.ID)
  Y.COUNT.C = DCOUNT(Y.COLL.ID,VM)
  FOR Y.C = 1 TO Y.COUNT.C
    IF Y.COLL.ALL.ID THEN
      Y.COLL.ALL.ID :=VM:Y.COLL.ID<1,Y.C>
    END ELSE
      Y.COLL.ALL.ID = Y.COLL.ID<1,Y.C>
    END
  NEXT Y.C


* =======
GET.LIMIT:
* =======
  Y.COUNT = DCOUNT(Y.COLL.ALL.ID,VM)
  FOR Y.I = 1 TO Y.COUNT
    Y.COLL.ALL.ID.AUX = Y.COLL.ALL.ID<1,Y.I>
    Y.COLL.RI.ID=Y.COLL.ALL.ID.AUX[".",1,2]

    CALL F.READ(FN.COLLATERAL.RIGHT,Y.COLL.RI.ID,R.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT,ERR.MSJ)
    IF ERR.MSJ THEN
      ETEXT = "EB-FC-READ.ERROR" : FM : FN.COLLATERAL.RIGHT
      CALL STORE.END.ERROR
      RETURN
    END
    Y.LIMIT = R.COLLATERAL.RIGHT<COLL.RIGHT.LIMIT.REFERENCE>
    GOSUB GET.ID.ARR

  NEXT Y.I
  RETURN

* ========
GET.ID.ARR:
* ========
  Y.COUNT = DCOUNT(Y.LIMIT,VM)
  FOR Y.I = 1 TO Y.COUNT
    CALL F.READ(FN.REDO.FC.LIMIT.AA, Y.LIMIT<1,Y.I>, R.REDO.FC.LIMIT.AA, F.REDO.FC.LIMIT.AA, Y.ERR)
* Start PACS00169926
* IF Y.ERR THEN
*     ETEXT = "EB-FC-READ.ERROR" : FM : FN.REDO.FC.LIMIT.AA
*     CALL STORE.END.ERROR
*     RETURN
* END
*End PACS00169926

    IF R.REDO.FC.LIMIT.AA THEN
      CALL F.READ(FN.AA.BILL.DETAILS, R.REDO.FC.LIMIT.AA, R.AA.BILL.DETAILS, F.AA.BILL.DETAILS, Y.ERR)
      IF R.AA.BILL.DETAILS THEN
        GOSUB CHECK.DUE
      END
    END
  NEXT Y.I
  RETURN

* =========
CHECK.DUE:
* =========
  Y.BILL.TYPE = R.AA.BILL.DETAILS<AA.BD.BILL.TYPE>
  Y.BILL.STATUS = R.AA.BILL.DETAILS<AA.BD.BILL.STATUS>
  Y.SETTLE.STATUS = R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS>

  IF Y.BILL.TYPE EQ "PAYMENT" THEN
    AF = Y.NAME.FIELD.ID
    AV= Y.C
    ETEXT = "EB-AA.BALANCE-DUE"
    CALL STORE.END.ERROR

  END

  IF Y.BILL.STATUS EQ "DUE" OR Y.BILL.STATUS EQ "AGING" THEN
    AF = Y.NAME.FIELD.ID
    AV= Y.C
    ETEXT = "EB-AA.BALANCE-DUE"
    CALL STORE.END.ERROR

  END

  IF Y.SETTLE.STATUS EQ "UNPAID" THEN
    AF = Y.NAME.FIELD.ID
    AV= Y.C
    ETEXT = "EB-AA.BALANCE-DUE"
    CALL STORE.END.ERROR


  END

  RETURN

* =========
OPEN.FILES:
* =========
  CALL OPF(FN.REDO.APP.MAPPING,F.REDO.APP.MAPPING)
  CALL OPF(FN.REDO.FC.PROD.COLL.POLICY,F.REDO.FC.PROD.COLL.POLICY)
  CALL OPF(FN.COLLATERAL.RIGHT,F.COLLATERAL.RIGHT)
  CALL OPF(FN.REDO.FC.LIMIT.AA,F.REDO.FC.LIMIT.AA)
  CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

  RETURN

* =========
INITIALISE:
* =========
  FN.REDO.APP.MAPPING = 'F.REDO.APP.MAPPING'
  F.REDO.APP.MAPPING = ''
  R.REDO.APP.MAPPING = ''

  FN.REDO.FC.PROD.COLL.POLICY = 'F.REDO.FC.PROD.COLL.POLICY'
  F.REDO.FC.PROD.COLL.POLICY = ''
  R.REDO.FC.PROD.COLL.POLICY = ''

  FN.COLLATERAL.RIGHT = 'F.COLLATERAL.RIGHT'
  F.COLLATERAL.RIGHT = ''
  R.COLLATERAL.RIGHT = ''

  FN.REDO.FC.LIMIT.AA = 'F.REDO.FC.LIMIT.AA'
  F.REDO.FC.LIMIT.AA = ''

  FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
  F.AA.BILL.DETAILS = ''

  Y.COLL.ALL.ID = ''
  Y.TYPE.COLL = ''
  Y.LIMIT = ''

  RETURN

END
