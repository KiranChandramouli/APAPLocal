*-----------------------------------------------------------------------------
* <Rating>-32</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.CONV.SEL.DISP
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.SELECTION.CR
*--------------------------------------------------------------------------------------------------------
*Description       : This is a CONVERSION routine attached to an enquiry, the routine fetches the value
*                    from O.DATA delimited with stars and formats them according to the selection criteria
*                    and returns the value back to O.DATA
*Linked With       : Enquiry REDO.AZ.DYNAMIC.DEPOSITS
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date                 Who                  Reference                 Description
*     ------               -----               -------------              -------------
*    26 09 2010       Jeyachandran S          ODR-2010-03-0166          Initial Creation
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
  GOSUB INITIALIZE
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
****************
INITIALIZE:
***************
  Y.CRITERIA = ''
  Y.AGENCY = ''
  Y.ACC.EXE = ''
  Y.DATE = ''
  RETURN
*************
PROCESS.PARA:
*************

  LOCATE 'AGENCY' IN D.FIELDS<1> SETTING Y.AGENCY.POS THEN
    Y.AGENCY = D.RANGE.AND.VALUE<Y.AGENCY.POS>
  END

  IF Y.AGENCY THEN
    IF Y.CRITERIA EQ '' THEN
      Y.CRITERIA = 'AGENCIA - ':Y.AGENCY
    END ELSE
      Y.CRITERIA = ',':'AGENCIA - ':Y.AGENCY
    END
  END

  LOCATE 'ACCT.EXECUTIVE' IN D.FIELDS<1> SETTING Y.ACCT.EXE.POS THEN
    Y.ACCT.EXECUTIVE = D.RANGE.AND.VALUE<Y.ACCT.EXE.POS>
  END

  IF Y.ACCT.EXECUTIVE THEN
    IF Y.CRITERIA EQ '' THEN
      Y.CRITERIA := 'OFICIAL DE CUENTA - ':Y.ACCT.EXECUTIVE
    END ELSE
      Y.CRITERIA := ',':'OFICIAL DE CUENTA - ':Y.ACCT.EXECUTIVE
    END
  END


  LOCATE 'DATE' IN D.FIELDS<1> SETTING Y.DATE.POS THEN
    Y.DATE = D.RANGE.AND.VALUE<Y.DATE.POS>
  END

  IF Y.DATE THEN

    Y.FROM.DATE = FIELD(Y.DATE,SM,1)
    Y.TO.DATE = FIELD(Y.DATE,SM,2)
    IF NOT(NUM(Y.FROM.DATE)) OR NOT(NUM(Y.TO.DATE)) THEN
      ENQ.ERROR = "EB-DATE.NOT.VALID"
      RETURN
    END
    IF LEN(Y.FROM.DATE) NE 8 OR LEN(Y.TO.DATE) NE 8 THEN
      ENQ.ERROR = "EB-DATE.NOT.VALID"
      RETURN
    END
    IF Y.FROM.DATE AND NOT(Y.TO.DATE) THEN
      ENQ.ERROR = "EB-TO.DATE.MAND"
      RETURN
    END
    IF NOT(Y.FROM.DATE) AND Y.TO.DATE THEN
      ENQ.ERROR = "EB-FROM.DATE.MAND"
      RETURN
    END
    IF Y.FROM.DATE GT Y.TO.DATE THEN
      ENQ.ERROR = "EB-TO.DATE.SHOULD.GT.FROM.DATE"
      RETURN
    END

    CALL EB.DATE.FORMAT.DISPLAY(Y.FROM.DATE, Y.FMT.DATE1, '', '')
    CALL EB.DATE.FORMAT.DISPLAY(Y.TO.DATE, Y.FMT.DATE2, '', '')

    Y.SEL.DISP = Y.FMT.DATE1:" - ":Y.FMT.DATE2

    IF Y.CRITERIA EQ '' THEN
      Y.CRITERIA := 'FECHA - ':Y.SEL.DISP
    END ELSE
      Y.CRITERIA := ',':'FECHA - ':Y.SEL.DISP
    END
  END


  O.DATA = Y.CRITERIA

  RETURN
*--------------------------------------------------------------------------------------------------------
END       ;* End of program
