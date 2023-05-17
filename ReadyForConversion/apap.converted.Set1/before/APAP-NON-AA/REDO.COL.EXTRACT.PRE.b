* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.EXTRACT.PRE(Y.CUSTOMER.ID)
*-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT SERVICE PRE-PROCESS
*
* - This routine checks if the Y.CUSTOMER.ID has arrangement accounts
* - If the last condition is true, then input the record into REDO.COL.EXTRACT.CONTROL
*   If at least one the account entry is AA, then the record is recorded
*
* ------
* TODO: Change the logic, and kept into REDO.COL.EXTRACT.CONTROL the list of arrangement to process
*
*-----------------------------------------------------------------------------
* Modification History:
*       2010-11-16 : C.1 APAP - First version
*
*       2011-06-20 : C.1 APAP - PACS00056294 - hpasquel@temenos.com
*                    Last.Process.Date must be take into account for processing
*       2011-09-14 : C.1 APAP -  PACS00110378 - jvalarezoulloa@temenos.com
*            just get all Customers extracte from AA and store in QUEUE
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.AA.ARRANGEMENT
$INSERT I_F.DATES ;*
*
$INSERT I_REDO.COL.EXTRACT.PRE.COMMON
*

  IF C.ALREADY.PROCESSED THEN
    CALL OCOMO("THIS ROUTINES MUST NOT BE CALLED, MAY BE AN ERROR")
    RETURN
  END


  R.REDO.EXTRAC.CONTROL = ""
  R.REDO.EXTRAC.CONTROL = Y.CUSTOMER.ID

*  WRITE R.REDO.EXTRAC.CONTROL TO F.REDO.COL.EXTRACT.CONTROL, Y.CUSTOMER.ID ;*Tus Start 
CALL F.WRITE(FN.REDO.COL.EXTRACT.CONTROL,Y.CUSTOMER.ID,R.REDO.EXTRAC.CONTROL);*Tus End


  RETURN

END
