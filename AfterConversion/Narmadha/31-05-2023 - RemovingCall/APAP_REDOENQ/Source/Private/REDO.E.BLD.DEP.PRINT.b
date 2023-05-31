$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.BLD.DEP.PRINT(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : SUDHARSANAN S
* Program Name  : REDO.E.BLD.DEP.PRINT
*-------------------------------------------------------------------------
* Description: This routine is a build routine attached to all enquiries
* which have used to generate the deposit slip print
*----------------------------------------------------------
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion  - FM to @FM and ++ to +=
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON

    GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PGM.END

RETURN

*---------
OPENFILES:
*---------

    FN.AZ.CUSTOMER = 'F.AZ.CUSTOMER'
    F.AZ.CUSTOMER = ''
    CALL OPF(FN.AZ.CUSTOMER,F.AZ.CUSTOMER)

    FN.DEP.REPRINT = 'F.REDO.DEP.REPRINT.DETAILS'
    F.DEP.REPRINT  = ''
    CALL OPF(FN.DEP.REPRINT,F.DEP.REPRINT)

RETURN
*-------
PROCESS:
*-----------------------------------------
* Main enquiry process is carried on here
*-----------------------------------------

    VAR.AZ.ID = '' ; Y.CUS.NO = ''

    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING ID.POS THEN

        VAR.AZ.ID =  ENQ.DATA<4,ID.POS>

        R.DEP.REPRINT = ''

        CALL F.READ(FN.DEP.REPRINT,VAR.AZ.ID,R.DEP.REPRINT,F.DEP.REPRINT,REPRINT.ERR)

        IF R.DEP.REPRINT THEN

            ENQ.DATA<4,ID.POS> = 'ZZZZZ'

        END

    END

    LOCATE 'CUSTOMER' IN ENQ.DATA<2,1> SETTING CUS.POS THEN

        Y.CUS.NO  =  ENQ.DATA<4,CUS.POS>

        R.AZ.CUSTOMER = ''

        CALL F.READ(FN.AZ.CUSTOMER,Y.CUS.NO,R.AZ.CUSTOMER,F.AZ.CUSTOMER,AZ.CUS.ERR)

        IF NOT(R.AZ.CUSTOMER) THEN

            ENQ.DATA<4,CUS.POS> = 'XXXX'

        END ELSE

            GOSUB CHECK.AZ.DEP

        END

    END

RETURN
*-------------
CHECK.AZ.DEP:
*----------------------------------------------
* Check the az number available in reprint file
*-----------------------------------------------

    VALID.AZ.ACCTS = ''

    AZ.CNT = DCOUNT(R.AZ.CUSTOMER,@FM)

    CNT = 1

    LOOP

    WHILE CNT LE AZ.CNT

        Y.AZ.ID = R.AZ.CUSTOMER<CNT>

        R.DEP.REPRINT = ''

        CALL F.READ(FN.DEP.REPRINT,Y.AZ.ID,R.DEP.REPRINT,F.DEP.REPRINT,REPRINT.ERR)

        IF NOT(R.DEP.REPRINT) THEN

            VALID.AZ.ACCTS<-1> = Y.AZ.ID

        END

        CNT += 1
    REPEAT

    IF VAR.AZ.ID THEN

        LOCATE VAR.AZ.ID IN VALID.AZ.ACCTS SETTING AZ.POS THEN
            ENQ.DATA<2,CUS.POS> = "@ID"
            ENQ.DATA<4,CUS.POS> = VAR.AZ.ID
        END ELSE
            ENQ.DATA<4,ID.POS> = 'ZZZZZ'
            ENQ.DATA<4,CUS.POS> = 'XXXX'
        END
        GOSUB PGM.END
    END

    IF VALID.AZ.ACCTS THEN

        CHANGE @FM TO ' ' IN VALID.AZ.ACCTS

        ENQ.DATA<2,CUS.POS> = "@ID"

        ENQ.DATA<4,CUS.POS> = VALID.AZ.ACCTS

    END ELSE

        ENQ.DATA<4,CUS.POS> = 'XXXX'

    END

RETURN
*--------------------------------------------------
PGM.END:
*--------
END
