*-----------------------------------------------------------------------------
* <Rating>-36</Rating>
*-----------------------------------------------------------------------------
  PROGRAM CORRECT.ACCT.STMT
*-----------------------------------------------------------------------------
* Thi routine Select the ACCOUNT.STATEMENT with @ID like 3A...
* And open the ACCOUNT.STATEMENT to check PRINT.STMT equal to Null
* And then, set the field PRINT.STMT as NO in ACCOUNT.STATEMENT record
* which will restrict the statements to be generated during month end.
*
* Author : Senthil Prabhu M
*
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT.STATEMENT

  GOSUB INIT
  GOSUB OPEN.FILE
  GOSUB PROCESS

  RETURN

*----
INIT:
*----
* Initialize the Necessary Variable

  SEL.CMD = '' ; SEL.LIST = ''
  Y.ACCOUNT.STMT = ''

  RETURN

*---------
OPEN.FILE:
*---------
* Open the Necessary Files

  FN.ACCOUNT.STATEMENT = 'F.ACCOUNT.STATEMENT'
  F.ACCOUNT.STATEMENT = ''
  CALL OPF(FN.ACCOUNT.STATEMENT, F.ACCOUNT.STATEMENT)

  RETURN

*-------
PROCESS:
*-------
* Unwanted accounts can be extracted from the below select commands
* then set the field PRINT.STMT as NO in ACCOUNT.STATEMENT record
* which will restrict the statements to be generated during month end.

  SEL.CMD = "SELECT FBNK.ACCOUNT.STATEMENT WITH PRINT.STMT EQ '' AND @ID LIKE 3A..."
  PRINT 'Selecting... ': SEL.CMD
  CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.REC,PGM.ERR)
  PRINT 'Total Number of Record Selected ' : NO.REC
  LOOP
    REMOVE Y.ACCOUNT.STMT FROM SEL.LIST SETTING ACC.POS
  WHILE Y.ACCOUNT.STMT:ACC.POS
    CALL F.READ(FN.ACCOUNT.STATEMENT, Y.ACCOUNT.STMT, R.ACCOUNT.STMT, F.ACCOUNT.STATEMENT, Y.ERROR)
    IF R.ACCOUNT.STMT THEN
      IF R.ACCOUNT.STMT<AC.STA.PRINT.STMT> = '' THEN
        PRINT 'Processing Account Number ... ' : Y.ACCOUNT.STMT
        R.ACCOUNT.STMT<AC.STA.PRINT.STMT> = 'NO'
        CALL F.WRITE(FN.ACCOUNT.STATEMENT, Y.ACCOUNT.STMT, R.ACCOUNT.STMT)
        CALL JOURNAL.UPDATE(Y.ACCOUNT.STMT)
      END
    END
  REPEAT
  RETURN
*-----------------------------------------------------------------------------
END

