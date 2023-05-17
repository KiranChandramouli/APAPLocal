*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.BUILD.REDO.ACCBYCUS(ENQ.DATA)
*----------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : PRAKASH G K S
* Program Name : REDO.FC.E.ACCBYCUS
*----------------------------------------------------------

* Description   : Used to get current Account

* Linked with   : Enquiry
* In Parameter  : CUSTOMER
* Out Parameter : ACCOUNTS SELECTED
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
*DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
*18.04.2013     PACS00253689          PRAKASH G K S           INITIAL CREATION
*---------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.CUSTOMER
$INSERT I_F.AI.REDO.ARCIB.PARAMETER

  GOSUB INIT
  GOSUB PROCESS
  RETURN

*---------------------------------------------------------------------------------
INIT:
*---------------------------------------------------------------------------------

  CUS.ID = ENQ.DATA<4,1>
  FIN.ACCOUNTS.LIST = ''

  FN.AI.REDO.ARCIB.PARAMETER = 'F.AI.REDO.ARCIB.PARAMETER'
  F.AI.REDO.ARCIB.PARAMETER = ''
  R.AI.REDO.ARCIB.PARAMETER = ''
*  CALL OPF(FN.AI.REDO.ARCIB.PARAMETER,F.AI.REDO.ARCIB.PARAMETER);*Tus (S/E)

  FN.CUSTOMER.ACCOUNT = 'F.CUSTOMER.ACCOUNT'
  F.CUSTOMER.ACCOUNT = ''
  R.CUSTOMER.ACCOUNT = ''
  CALL OPF(FN.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT)

  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  R.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN

*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

  CALL F.READ(FN.CUSTOMER.ACCOUNT,CUS.ID,R.CUSTOMER.ACCOUNT,F.CUSTOMER.ACCOUNT,CUS.ERR)

  CALL CACHE.READ(FN.AI.REDO.ARCIB.PARAMETER,'SYSTEM',R.AI.REDO.ARCIB.PARAMETER,REDO.ARCIB.ERR)

  NO.OF.ACCTS = DCOUNT(R.CUSTOMER.ACCOUNT,FM)

  ACC.LP.NO = '1'
  LOOP
  WHILE ACC.LP.NO LE NO.OF.ACCTS
    CUR.ACC.NO = R.CUSTOMER.ACCOUNT<ACC.LP.NO>

    CALL F.READ(FN.ACCOUNT,CUR.ACC.NO,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    ACC.CATEG = R.ACCOUNT<AC.CATEGORY>


    CATEG.START = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CATEG.START>
    CATEG.END = R.AI.REDO.ARCIB.PARAMETER<AI.PARAM.CATEG.END>

    CATEG.COUNT = DCOUNT(CATEG.START,VM)
    CATEG.STRT = '1'
    LOOP
    WHILE CATEG.STRT LE CATEG.COUNT

      IF ACC.CATEG GE CATEG.START<1,CATEG.STRT> AND ACC.CATEG LE CATEG.END<1,CATEG.STRT> THEN
        FIN.ACCOUNTS.LIST<-1> = CUR.ACC.NO
      END
      CATEG.STRT+=1
    REPEAT

    CHANGE FM TO ' ' IN FIN.ACCOUNTS.LIST

    ENQ.DATA<2,1> = '@ID'
    ENQ.DATA<3,1> = 'EQ'
    ENQ.DATA<4,1> = FIN.ACCOUNTS.LIST

    ACC.LP.NO += 1
  REPEAT

  RETURN

END
