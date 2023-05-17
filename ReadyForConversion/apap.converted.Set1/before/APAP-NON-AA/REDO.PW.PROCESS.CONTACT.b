*-------------------------------------------------------------------------
* <Rating>-30</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE  REDO.PW.PROCESS.CONTACT(R.DATA,L.PROCESS.ID)
*-------------------------------------------------------------------------
*DESCRIPTION:
*------------
* This PW routine will map the Process Id

* INPUT/OUTPUT:
*--------------
* IN  : R.DATA
* OUT : L.CUST.ID
*-------------------------------------------------------------------------
*   Date               who           Reference            Description
* 13-SEP-2011     SHANKAR RAJU     ODR-2011-07-0162      Initial Creation
*-------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_PW.COMMON
$INSERT I_F.PW.PROCESS

  GOSUB INIT
  GOSUB PROCESS

  RETURN

INIT:
*----

  FN.CR.CONTACT.LOG = "F.CR.CONTACT.LOG"
  F.CR.CONTACT.LOG  = ""
  CALL OPF(FN.CR.CONTACT.LOG,F.CR.CONTACT.LOG)

  RETURN

PROCESS:
*-------

  SEL.CMD = "SELECT ":FN.CR.CONTACT.LOG:" WITH CONTACT.CLIENT EQ ":R.NEW(PW.PROC.CUSTOMER):" AND CONTACT.CHANNEL EQ CALLCENTRE"
  SEL.CMD := " AND CONTACT.DIRECTION EQ OUTWARD AND CONTACT.DESC EQ 'Outbound Campaign Loans (AA)' AND CONTACT.STATUS EQ ACEPTA"

  CALL EB.READLIST(SEL.CMD,CR.CONTACT.ID,'',NO.OF.REC,CR.ERR)

  L.PROCESS.ID = CR.CONTACT.ID<NO.OF.REC>

  RETURN
END
