*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.DATECONV(ENQ.DATA)
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.DATECONV
*--------------------------------------------------------------------------------------------------------
*Description       : This build routine is used to convert the date time from selection fields. *
*
*Linked With       : Enquiry REDO.INVESTMENT.REINVESTMENT.R94
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 13 August 2010      Jeyachandran S       ODR-2010-03-0094 103         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.RESTRICTIVE.LIST
*
  GOSUB PROCESS
  GOSUB GOEND
  RETURN
*
*********
PROCESS:
*********

  Y.SEL.FIELD = ENQ.DATA<2>
  LOCATE "DATE.TIME" IN Y.SEL.FIELD<1,1> SETTING Y.DT.POS THEN
    Y.FR.TO.DATE = ENQ.DATA<4,Y.DT.POS>
    IF Y.FR.TO.DATE THEN

      Y.FROM.DATE = FIELD(Y.FR.TO.DATE," ",1)
      Y.TO.DATE = FIELD(Y.FR.TO.DATE," ",2)

      Y.FROM.DATE = Y.FROM.DATE[3,8]:"0000"
      Y.TO.DATE = Y.TO.DATE[3,8]:"2400"

      ENQ.DATA<4,Y.DT.POS> = Y.FROM.DATE:" ":Y.TO.DATE
    END
  END
  RETURN

************
GOEND:
************
END
