SUBROUTINE REDO.APAP.CUST.SWIFT.DET.AUTHORISE

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_Table
    $INSERT I_F.REDO.APAP.CUST.SWIFT.DET


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.REDO.APAP.CUST.SWIFT.CONCAT = 'F.REDO.APAP.CUST.SWIFT.CONCAT'
    F.REDO.APAP.CUST.SWIFT.CONCAT  = ''
    CALL OPF(FN.REDO.APAP.CUST.SWIFT.CONCAT,F.REDO.APAP.CUST.SWIFT.CONCAT)
RETURN


PROCESS:
********
    YCUST = R.NEW(REDO.CUSW.CUSTOMER.ID)
    IF YCUST NE '' THEN
        ERR.REDO.APAP.CUST.SWIFT.CONCAT = ''; R.REDO.APAP.CUST.SWIFT.CONCAT = ''
        CALL F.READ(FN.REDO.APAP.CUST.SWIFT.CONCAT,YCUST.ID,R.REDO.APAP.CUST.SWIFT.CONCAT,F.REDO.APAP.CUST.SWIFT.CONCAT,ERR.REDO.APAP.CUST.SWIFT.CONCAT)

        LOCATE YCUST IN R.REDO.APAP.CUST.SWIFT.CONCAT SETTING EL.POSN ELSE
            R.REDO.APAP.CUST.SWIFT.CONCAT<-1> = ID.NEW
            CALL F.WRITE(FN.REDO.APAP.CUST.SWIFT.CONCAT,YCUST,R.REDO.APAP.CUST.SWIFT.CONCAT)
        END
    END
RETURN
END
