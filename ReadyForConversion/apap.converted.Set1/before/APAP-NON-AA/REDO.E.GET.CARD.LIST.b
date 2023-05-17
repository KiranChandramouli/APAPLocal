*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.GET.CARD.LIST(Y.FINAL.ARRAY)

*---------------------------------------------------------------------------------
* This is an enquiry for listing all the credit cards of the customer
*this enquiry will fetch the data from sunnel interface
*---------------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   : Prabhu N
* Program Name   : REDO.E.GET.CARD.LIST
* ODR NUMBER     : SUNNEL-CR
* LINKED WITH    : ENQUIRY-REDO.CCARD.LIST
*---------------------------------------------------------------------------------
*IN = N/A
*OUT = Y.FINAL.ARRAY
*---------------------------------------------------------------------------------
*MODIFICATION:
*---------------------------------------------------------------------------------
* DATE           ODR                   DEVELOPER               VERSION
*--------       ----------------      -------------           --------------------
* 3.12.2010     PACS00036498           Prabhu N                Initial creation
* 21-04-2011    PACS00032454           GANESH H                 MODIFICATION
*---------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_System

  GOSUB INITIALISE
  GOSUB PROCESS

  RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*---------------------------------------------------------------------------------

  Y.CUSTOMER.ID = System.getVariable('EXT.CUSTOMER')
  
  ACTIVATION = 'WS_T24_VPLUS'
  WS.DATA = ''
  WS.DATA<1> = 'ADICIONALES_CLIENTE'
  WS.DATA<2> = Y.CUSTOMER.ID

  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*---------------------------------------------------------------------------------

* Invoke VisionPlus Web Service
  CALL REDO.VP.WS.CONSUMER(ACTIVATION, WS.DATA)

* Credit Card exits - Info obtained OK
  IF WS.DATA<1> EQ 'OK' THEN

    Y.ADDITI0NAL.LIST = WS.DATA<2>
    Y.ADDITI0NAL.LIST = CHANGE(Y.ADDITI0NAL.LIST,'*',VM)

    Y.TOT.LIST = DCOUNT(Y.ADDITI0NAL.LIST,VM)
    Y.CNT = 1
    IF WS.DATA<7,Y.TOT.LIST> EQ '' THEN
      Y.TOT.LIST = Y.TOT.LIST -1
    END

    LOOP
    WHILE Y.CNT LE Y.TOT.LIST
      Y.ADD.CARD = Y.ADDITI0NAL.LIST<1,Y.CNT>
      Y.FINAL.ARRAY<-1> = Y.ADD.CARD:'###':Y.CNT
      Y.CNT++
    REPEAT
  END ELSE
* 'ERROR/OFFLINE'
    ENQ.ERROR<1> = ''
  END

  RETURN
END
*------------------------------*END OF SUBROUTINE*--------------------------------
