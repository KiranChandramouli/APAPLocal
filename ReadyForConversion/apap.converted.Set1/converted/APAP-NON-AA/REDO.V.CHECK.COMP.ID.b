SUBROUTINE REDO.V.CHECK.COMP.ID
*-----------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
*DESCRIPTION : This is used as ID routine in COMPLAINTS to check the TRANSACTIONS are valid or not
*-----------------------------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : Sakthi Sellappillai
* PROGRAM NAME : REDO.V.CHECK.COMP.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE            WHO                     REFERENCE             DESCRIPTION
* 07-10-2010      Sakthi Sellappillai      ODR-2010-08-0031       INITIAL CREATION
* ----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ISSUE.COMPLAINTS
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------------------------------
INIT:
*-----------------------------------------------------------------------------------------------------
    Y.CUR.VAR = ''
    Y.CURRENT.TRANS.VAL = ''
RETURN
*-----------------------------------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------------------------------

    CALL BUILD.USER.VARIABLES(Y.CUR.VAR)
    IF NOT(Y.CURRENT.TRANS.VAL) THEN
        Y.VAR.COUNT=DCOUNT(Y.CUR.VAR,@FM)
        LOOP
            REMOVE Y.VAR1 FROM Y.CUR.VAR SETTING POS
        WHILE Y.CURRENT.TRANS.VAL EQ '' AND Y.VAR1:POS
            IF FIELD(Y.VAR1,'*',1,1) EQ 'CURRENT.TRANSACTION.VAL' THEN
                Y.CURRENT.TRANS.VAL = FIELD(Y.VAR1,'*',2,1)
            END
        REPEAT
    END
    IF Y.CURRENT.TRANS.VAL EQ '' THEN
        E = 'EB-ENTRIES.NOT.RAISED'
    END
RETURN
*----------------------------------------------------------------------------------------------
END
