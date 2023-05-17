SUBROUTINE REDO.E.BLD.ACCT.OFF(ENQ.DATA)
*----------------------------------------------------------------------------
* Description:
***************
*
*  This build routine is to be attached to the ENQUIRY REDO.ACCT.OFFICER
*------------------------------------------------------------------------------------------
* * Input / Output
*
* --------------
* IN     : ENQ.DATA
* OUT    : ENQ.DATA
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Arulprakasam P
* PROGRAM NAME : REDO.E.BLD.ACCT.OFF
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO            REFERENCE           DESCRIPTION
* 11.10.2010      Arulprakasam P  ODR-2010-09-0148    INITIAL CREATION
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.USER
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.REDO.APAP.CLEARING.INWARD

*GOSUB INIT
*GOSUB PROCESS
*IF Y.SELECTION AND NOT(Y.FLAG) THEN
*ENQ.DATA<4> = ''
*END
*Y.TEMP = ENQ.DATA


    ENQ.DATA<2,-1> = 'ACC.OFF.J'
    ENQ.DATA<3,-1> = 'EQ'
    ENQ.DATA<4,-1> = R.USER<EB.USE.DEPARTMENT.CODE>



RETURN

*-----------------------------------------------------------------------------------------------
*****
INIT:
*****

    FN.REDO.APAP.CLEARING.INWARD = 'F.REDO.APAP.CLEARING.INWARD'
    F.REDO.APAP.CLEARING.INWARD = ''
    CALL OPF(FN.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD)

    FN.DEPT.ACCT.OFFICER = 'F.DEPT.ACCT.OFFICER'
    F.DEPT.ACCT.OFFICER = ''
    CALL OPF(FN.DEPT.ACCT.OFFICER,F.DEPT.ACCT.OFFICER)

RETURN


*-----------------------------------------------------------------------------------------------
********
PROCESS:
********
    Y.SELECTION = ''
    IF ENQ.DATA<4> THEN
        SEL.CMD = "SELECT ":FN.REDO.APAP.CLEARING.INWARD:" WITH @ID EQ " :ENQ.DATA<4>
        Y.SELECTION = 1
    END ELSE
        SEL.CMD = "SELECT ":FN.REDO.APAP.CLEARING.INWARD
    END
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ERR)
    LOOP
        REMOVE REDO.INW.ID FROM SEL.LIST SETTING INW.POS
    WHILE REDO.INW.ID:INW.POS
        Y.FLAG = ''
        CALL F.READ(FN.REDO.APAP.CLEARING.INWARD,REDO.INW.ID,R.REDO.APAP.CLEARING.INWARD,F.REDO.APAP.CLEARING.INWARD,CLEAR.INW.ERR)
        Y.ACCT.OFF = R.REDO.APAP.CLEARING.INWARD<CLEAR.CHQ.ACCT.OFFICER>
        Y.DEPT.CODE = R.USER<EB.USE.DEPARTMENT.CODE>

        IF Y.ACCT.OFF EQ Y.DEPT.CODE THEN
            Y.FLAG = 1
            GOSUB PROCESS.ID
        END ELSE
            GOSUB CHECKDEPT.PARAENT
        END
    REPEAT
RETURN

*-----------------------------------------------------------------------------------------------
******************
CHECKDEPT.PARAENT:
******************

    CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, Y.ACCT.OFF, R.DEPT.ACCT.OFFICER, DEPT.ERR)
    Y.DEPT.PARENT = R.DEPT.ACCT.OFFICER<EB.DAO.DEPT.PARENT>

    IF Y.DEPT.PARENT EQ Y.DEPT.CODE THEN
        GOSUB PROCESS.ID
        Y.FLAG = 1
    END ELSE
        CALL CACHE.READ(FN.DEPT.ACCT.OFFICER, Y.DEPT.PARENT, R.DEPT.ACCT.OFFICER, DEPT.ERR)
        Y.DEPT.PARENT.1 = R.DEPT.ACCT.OFFICER<EB.DAO.DEPT.PARENT>
        GOSUB CHECKFINAL.PARENT
    END
RETURN

*-----------------------------------------------------------------------------------------------
******************
CHECKFINAL.PARENT:
******************

    IF Y.DEPT.PARENT.1 EQ Y.DEPT.CODE THEN
        Y.FLAG = 1
        GOSUB PROCESS.ID
    END
RETURN

*-----------------------------------------------------------------------------------------------
***********
PROCESS.ID:
***********
    IF NOT(Y.FLAG) THEN
        REDO.INW.ID = ''
    END ELSE

        ENQ.DATA<2,-1> = '@ID'
        ENQ.DATA<3,-1> = 'EQ'
        ENQ.DATA<4,-1> = REDO.INW.ID
    END
RETURN

END
