*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.CREDIT.CUSTOMER.POSITION(Y.FINAL.ARRAY)
*------------------------------------------------------------------------
*Description : This routine is nofile enquiry routine in order to fetch the
* credit card details of the customer

*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : Y.FINAL.ARRAY
* Deals With     : ENQUIRY>REDO.CREDIT.CUSTOMER.POSITION
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO         REFERENCE            DESCRIPTION
* 03-MAR-2011     H GANESH  ODR-2010-10-0045 N.107   Initial Draft
* 13-05-2011      GANESH H  PACS00063129             MODIFICATION
*------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.DATES
$INSERT I_System
$INSERT I_ENQUIRY.COMMON

  GOSUB INIT

  GOSUB PROCESS
  RETURN

*-------------------------------------------------------
INIT:
*-------------------------------------------------------
* Variables and files are opened here
  FN.REDO.EB.USER.PRINT.VAR='F.REDO.EB.USER.PRINT.VAR'
  F.REDO.EB.USER.PRINT.VAR=''
  CALL OPF(FN.REDO.EB.USER.PRINT.VAR,F.REDO.EB.USER.PRINT.VAR)
  CARD.LIST.NUMBER=''

  CLIENT.ID = System.getVariable("EXT.SMS.CUSTOMERS")
  Y.ARRAY='BE_K_TC.BE_P_CONSOLIDADOTC'
  CALL REDO.V.WRAP.SUNNEL(Y.ARRAY)
  RETURN
*-------------------------------------------------------
PROCESS:
*-------------------------------------------------------

  Y.ALL.DATA=Y.ARRAY<4>
  IF Y.ARRAY<2> NE '0' THEN
    ENQ.ERROR='EB-SUNNEL.VAL.FAIL'
    RETURN
  END
  LOCATE 'CLIENT.ID' IN D.FIELDS SETTING POS1 THEN
    Y.CUS.ID= D.RANGE.AND.VALUE<POS1>
  END
  Y.FINAL.ARRAY=''
  CHANGE VM TO FM IN Y.ALL.DATA
  CHANGE SM TO VM IN Y.ALL.DATA
  Y.DATA.CNT=DCOUNT(Y.ALL.DATA,FM)

  Y.VAR1=1
  LOOP
  WHILE Y.VAR1 LE Y.DATA.CNT
    Y.ALL=Y.ALL.DATA<Y.VAR1>

!PACS00063129-S
    CUSTOMER.CARD.LIST<-1>=Y.ALL<1,5>
!  CALL System.setVariable("CURRENT.CARD.LIST.CUS",CUSTOMER.CARD.LIST)
    Y.FINAL.ARRAY<-1>=Y.ALL<1,1>:'*':Y.ALL<1,2>:'*':Y.ALL<1,3>:'*':Y.ALL<1,4>:'*':Y.ALL<1,5>:'*':Y.ALL<1,6>:'*':Y.ALL<1,7>:'*':Y.ALL<1,8>:'*':Y.ALL<1,9>:'*':Y.ALL<1,10>:'*':Y.ALL<1,11>:'*':Y.ALL<1,12>:'*':Y.ALL<1,13>:'*':Y.ALL<1,14>:'*':Y.ALL<1,15>
    Y.VAR1++
  REPEAT
  CHANGE FM TO '*' IN CUSTOMER.CARD.LIST
*    CALL System.setVariable("CURRENT.CARD.LIST.CUS",CUSTOMER.CARD.LIST)


  Y.USR.VAR = System.getVariable("EXT.EXTERNAL.USER")

  Y.USR.VAR = Y.USR.VAR:"-":"CURRENT.CARD.LIST.CUS"

*  WRITE CUSTOMER.CARD.LIST TO F.REDO.EB.USER.PRINT.VAR,Y.USR.VAR ;*Tus Start 
CALL F.WRITE(FN.REDO.EB.USER.PRINT.VAR,Y.USR.VAR,CUSTOMER.CARD.LIST) ;*Tus End
!PACS00063129-E

  RETURN
END
