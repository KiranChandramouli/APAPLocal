*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CONV.SEL.CRITERIA
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.CONV.SEL.CRITERIA
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.APAP.NOF.SERIES.REPORT.NO
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
* 13 August 2010       Shiva Prasad Y      ODR-2010-03-0158 103         Initial Creation
*
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON

*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
* This is the para from where the execution of the code starts
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
* This is the main processing para

  Y.CRITERIA = ''

  Y.SR.ALLOC.TIME  = FIELD(O.DATA,'*',1,1)
  Y.INS.TYPE       = FIELD(O.DATA,'*',2,1)
  Y.SR.CANCEL.TIME = FIELD(O.DATA,'*',3,1)

*   Y.SR.ALLOC.TIME = FMT(Y.SR.ALLOC.TIME, 'D4')
  Y.SR.ALLOC.TIME = OCONV(ICONV(Y.SR.ALLOC.TIME,"D"),"D4")
*   Y.SR.CANCEL.TIME = FMT(Y.SR.CANCEL.TIME, 'D4')
  Y.SR.CANCEL.TIME = OCONV(ICONV(Y.SR.CANCEL.TIME,"D"),"D4")

  IF Y.SR.ALLOC.TIME THEN
*       Y.CRITERIA = 'Series Allocation Date: ':Y.SR.ALLOC.TIME:' '
    Y.CRITERIA = 'FECHA ASIGNACION SERIE : ':Y.SR.ALLOC.TIME:'; '
  END

  IF Y.INS.TYPE THEN
*        Y.CRITERIA := 'Instrument Type - ':Y.INS.TYPE:' '
*        IF Y.CRITERIA NE '' THEN
*            Y.CRITERIA = Y.CRITERIA:'; '
*        END
    Y.CRITERIA := 'TIPO DE INVERSION : ':Y.INS.TYPE:'; '
  END

  IF Y.SR.CANCEL.TIME THEN
*        Y.CRITERIA := 'Series Cancellation Date - ':Y.SR.CANCEL.TIME:' '
*        IF Y.CRITERIA NE '' THEN
*            Y.CRITERIA = Y.CRITERIA:', '
*        END
    Y.CRITERIA := 'FECHA ANULAC. SERIE : ':Y.SR.CANCEL.TIME:'; '
  END

  IF Y.CRITERIA EQ '' THEN
    Y.CRITERIA = 'TODOS'
  END
  O.DATA = Y.CRITERIA


  RETURN
*--------------------------------------------------------------------------------------------------------
END
