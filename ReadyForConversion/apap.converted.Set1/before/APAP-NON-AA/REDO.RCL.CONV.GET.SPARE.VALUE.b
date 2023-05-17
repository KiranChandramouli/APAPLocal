*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RCL.CONV.GET.SPARE.VALUE
*-----------------------------------------------------------------------------------------------------------------
* Description           : This is a common conversion routine used to get the value from common variable C$SPARE
*                         which will be used in RCL records of all other APAP reports.
*
* Developed By          : Saranraj S
*
* Development Reference : DE04
*
* Attached To           : RCL>APAP.RCL.DE04
*
* Attached As           : COnversion Routine
*-----------------------------------------------------------------------------------------------------------------
*------------------------
* Input Parameter:
* ---------------*
* Argument#1 : NA
* Argument#2 : NA
* Argument#3 : NA
*-----------------------------------------------------------------------------------------------------------------
*-----------------*
* Output Parameter:
* ----------------*
* Argument#4 : NA
* Argument#5 : NA
* Argument#6 : NA
*-----------------------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*-----------------------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*(RTC/TUT/PACS)                                        (YYYY-MM-DD)
*-----------------------------------------------------------------------------------------------------------------
* XXXX                   <<name of modifier>>                                 <<modification details goes here>>
*-----------------------------------------------------------------------------------------------------------------
* Include files
*-----------------------------------------------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE

  Y.COMI = COMI

  COMI = C$SPARE(Y.COMI)
*
  RETURN
END
