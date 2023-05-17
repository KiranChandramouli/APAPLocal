*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.DISP.LASTFIVE.STO(ENQ.DATA)
*-----------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : Prabhu N
* Program Name : REDO.E.ELIM.LOAN.PRODUCT
*-----------------------------------------------------------------------------
* Description : This subroutine is attached as a BUILD routine in the Enquiry AI.REDO.LOAN.ACCT.TO
* In Parameter : ENQ.DATA
* Out Parameter : None
*
**DATE           ODR                   DEVELOPER               VERSION
*
*26/08/11      PACS00112995          Prabhu N                MODIFICAION
*19/09/11      PACS00125978          PRABHUN                 MODIFICATION
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System
$INSERT I_EB.EXTERNAL.COMMON
$INSERT I_F.CUSTOMER.ACCOUNT
$INSERT I_F.STMT.ENTRY
$INSERT I_F.FUNDS.TRANSFER


  GOSUB INITIALISE
  GOSUB GET.STO.DETAILS
  RETURN
*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------

  STO.WRK.ID=''
  CUSTOMER.ID = System.getVariable("EXT.SMS.CUSTOMERS")
  STO.WRK.ID = CUSTOMER.ID:"-":"T"

  FN.REDO.STO='F.REDO.STO.STORE.LASTFIVE'
  F.REDO.STO=''
  CALL OPF(FN.REDO.STO,F.REDO.STO)
  Y.STMT.ID.LIST=''

  DISP.CNT=1
  MAX.DISP.CNT=5

  RETURN
*----------------------------------------------------------------------------
GET.STO.DETAILS:
*-----------------------------------------------------------------------------
!PACS00125978-S

  CALL F.READ(FN.REDO.STO,STO.WRK.ID,R.REDO.STO.REC,F.REDO.STO,STO.ERR)
  IF NOT(STO.ERR) THEN
    LOOP
    WHILE DISP.CNT LE MAX.DISP.CNT
      Y.STMT.ID.LIST<-1> = R.REDO.STO.REC<DISP.CNT>
      DISP.CNT ++
    REPEAT

    CHANGE FM TO ' ' IN Y.STMT.ID.LIST
    ENQ.DATA<2,1>='@ID'
    ENQ.DATA<3,1>='EQ'
    ENQ.DATA<4,1>=Y.STMT.ID.LIST


  END ELSE
    ENQ.DATA<2,1>='@ID'
    ENQ.DATA<3,1>='EQ'
    ENQ.DATA<4,1>=''
  END
  RETURN
!PACS00125978-E
*-----------------------------------------------------------------------------
END
*---------------------------*END OF SUBROUTINE*-------------------------------
