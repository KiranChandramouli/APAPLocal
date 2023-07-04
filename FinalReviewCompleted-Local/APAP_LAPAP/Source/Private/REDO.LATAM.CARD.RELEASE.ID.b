* @ValidationCode : MjoxMjg1NzE1NDE5OkNwMTI1MjoxNjg0MjIyODMyNjA0OklUU1M6LTE6LTE6MjkwOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 290
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*MODIFICATION HISTORY:
*---------------------------------------------------------------------------------------
*DATE               WHO                       REFERENCE                 DESCRIPTION
*19-04-2023       CONVERSION TOOLS            AUTO R22 CODE CONVERSION   NO CHANGE
*19-04-2023       AJITHKUMAR                  MANUAL R22 CODE CONVERSION NO CHANGE
*----------------------------------------------------------------------------------------




SUBROUTINE REDO.LATAM.CARD.RELEASE.ID
*-----------------------------------------------------------------------------
*** FIELD definitions FOR TEMPLATE
*!
* @author youremail@temenos.com
* @stereotype id
* @package infra.eb
* @uses E
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-----------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------

    ID.ENTERED=ID.NEW
    CRD.TYP=FIELD(ID.NEW,".",1)
    COMP.CDE=FIELD(ID.NEW,".",2)

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

OPENFILES:

    FN.CARD.TYPE='F.CARD.TYPE'
    F.CARD.TYPE=''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)

    FN.COMPANY='F.COMPANY'
    F.COMPANY=''
    CALL OPF(FN.COMPANY,F.COMPANY)

RETURN


PROCESS:


    CALL F.READ(FN.CARD.TYPE,CRD.TYP,R.CARD.TYPE,F.CARD.TYPE,ERR)
    IF R.CARD.TYPE ELSE

        E = 'EB-NOT.VALID.CARD.TYPE'
    END

    IF COMP.CDE NE '' THEN

        IF COMP.CDE NE ID.COMPANY THEN

            CALL CACHE.READ(FN.COMPANY, COMP.CDE, R.COMP, ERR)

            IF R.COMP THEN

                E = "EB-CANNOT.ACCESS.COMPANY"

            END ELSE

                E = 'EB-NOT.VALID.COMPANY'
            END


        END ELSE
            RETURN
        END
    END ELSE

        ID.NEW=CRD.TYP:'.':ID.COMPANY

    END



RETURN




RETURN

END
