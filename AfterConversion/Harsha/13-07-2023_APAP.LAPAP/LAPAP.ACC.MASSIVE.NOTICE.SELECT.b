$PACKAGE APAP.LAPAP
*========================================================================
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.ACC.MASSIVE.NOTICE.SELECT
*========================================================================
* Technical report:
* =================
* Company Name   : APAP
* Program Name   : LAPAP.ACC.MASSIVE.NOTICE.SELECT
* Date           : 2019-05-21
* Item ID        : --------------
*========================================================================
* Brief description :
* -------------------
* This program allow ....
*========================================================================
* Modification History :
* ======================
* Date           Author            Modification Description
* -------------  -----------       ---------------------------
* 2019-05-21     Richard HC        Initial Development
*========================================================================
* Content summary :
* =================
* Table name     :F.ACCOUNT
* Auto Increment :N/A
* Views/versions :
* EB record      :N/A
* Routine        :LAPAP.ACC.MASSIVE.NOTICE.SELECT
*========================================================================
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 13-JULY-2023      Harsha                R22 Auto Conversion  - No changes
* 13-JULY-2023      Harsha                R22 Manual Conversion - BP removed from Inserts

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_LAPAP.ACC.MASSIVE.NOTICE.COMMON


    DIR.NAME = "../interface/T24ACCNOTICE"
    FILE.NAME = "LAPAP.ACC.MASSIVE.NOTICE.CSV"
    FILE.NAME2 = "LAPAP.ACC.MASSIVE.NOTICE.csv"

    OPENSEQ DIR.NAME,FILE.NAME TO FV.REC ELSE
        PRINT @(12,12): 'CANNOT OPEN DIRECTORY'

        OPENSEQ DIR.NAME,FILE.NAME2 TO FV.REC ELSE

            CALL OCOMO("CANNOT OPEN DIR ": DIR.NAME)

            CREATE FV.REC ELSE
                GOSUB NO.DATA
            END

        END

    END

    LOOP
        READSEQ Y.REC FROM FV.REC ELSE Y.EOF = 1
    WHILE  NOT(Y.EOF)

        ACC.ID<-1> = Y.REC

    REPEAT

    CALL BATCH.BUILD.LIST('',ACC.ID)

RETURN

*-------
NO.DATA:
*-------

    CALL OCOMO("NO HAY DATA EN EL ARCHIVO")
    ACC.ID = ''
    CALL BATCH.BUILD.LIST('',ACC.ID)

RETURN


END
