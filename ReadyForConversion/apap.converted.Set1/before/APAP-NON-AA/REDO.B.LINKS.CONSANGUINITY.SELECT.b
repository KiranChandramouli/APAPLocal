*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.LINKS.CONSANGUINITY.SELECT
*----------------------------------------------------------------------------------------------------------------
*
* Description           : This routine extracts the data from CUSTOMER as per the mapping provided
*
* Developed By          : Kalyani L K, Capgemini
*
* Development Reference : REGN6-GR05
*
* Attached To           : Batch - BNK/REDO.B.LINKS.CONSANGUINITY
*
* Attached As           : Multi Threaded Routine
*-----------------------------------------------------------------------------------------------------------------
* Input Parameter:
*----------------*
* Argument#1 : NA
*
*-----------------*
* Output Parameter:
*-----------------*
* Argument#2 : NA
*
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
* (RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* REGN6-GR05             Kalyani L K                     2014-02-18           Initial Draft
*
* PACS00361957           Ashokkumar.V.P                  19/02/2015           Optimized the relation between the customer
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
$INSERT I_REDO.B.LINKS.CONSANGUINITY.COMMON
*-----------------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para of the program, from where the execution of the code starts
**
  GOSUB PROCESS.PARA
  RETURN
*-----------------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* In this para of the program, the main processing starts
**
  CURR.MONTH = TODAY[5,2]
  CURR.MONTH = CURR.MONTH + 1 - 1

  LOCATE CURR.MONTH IN FIELD.GEN.VAL<1> SETTING FOUND.POS ELSE
    RETURN
  END

  SEL.TEMP = ''; SEL.CONT.LST = ''; SEL.CMD = ''; SEL.LIST = ''; NO.OF.REC = ''
  RET.CODE = ''; SEL.PRT2 = ''; SE.LIST1 = ''
  SEL.TEMP = "SSELECT ":FN.REDO.GR.REP.CUST:" WITH @ID LIKE ":REPORT.NAME:"..."
  EXECUTE SEL.TEMP RTNLIST SE.LIST1
  SEL.PRT2 = 'QSELECT ':FN.REDO.GR.REP.CUST
  EXECUTE SEL.PRT2 PASSLIST SE.LIST1 RTNLIST SEL.CONT.LST

  SEL.CMD = "SELECT ":FN.RELATION.CUSTOMER
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,RET.CODE)

  CALL BATCH.BUILD.LIST('',SEL.LIST)
  RETURN
*-----------------------------------------------------------------------------------------------------------------
END       ;*End of program
