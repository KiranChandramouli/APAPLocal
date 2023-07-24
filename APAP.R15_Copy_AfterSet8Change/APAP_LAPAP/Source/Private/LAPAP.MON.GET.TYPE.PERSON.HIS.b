* @ValidationCode : Mjo2MDcwMjUzMzU6Q3AxMjUyOjE2OTAxOTE2NzM3ODk6SGFyaXNodmlrcmFtQzotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Jul 2023 15:11:13
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>-1</Rating>
*-----------------------------------------------------------------------------
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*20-07-2023    VICTORIA S          R22 MANUAL CONVERSION   Folder name removed, CALL routine format modified
*----------------------------------------------------------------------------------------
SUBROUTINE LAPAP.MON.GET.TYPE.PERSON.HIS

    $INSERT I_COMMON ;*R22 MANUAL CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER ;*R22 MANUAL CONVERSION END - Folder name removed

*---------------------
* Defining prpierties
*---------------------

    FN.ACC = "F.ACCOUNT$HIS"
    F.ACC = ""
    CALL OPF(FN.ACC,F.ACC)


    FN.CUS = "F.CUSTOMER"
    F.CUS = ""
    CALL OPF(FN.CUS,F.CUS)

    ID = COMI

*---------------
* Opening Tables
*---------------

    ACC = ID
*    CALL LAPAP.VERIFY.ACC(ACC,RES)
    APAP.LAPAP.lapapVerifyAcc(ACC,RES)            ;*R22 MANUAL CONVERSION
    Y.ACC.ID = RES

    IF ACC NE Y.ACC.ID THEN

        CALL F.READ.HISTORY(FN.ACC,Y.ACC.ID,R.HIS,F.ACC,ERRH)
        CUSTOMER.ID = R.HIS<AC.CUSTOMER>

        CALL F.READ(FN.CUS,CUSTOMER.ID,R.CUS,F.CUS,ERRCUS)
        CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",POS)
        CUSTOMER.TYPE = R.CUS<EB.CUS.LOCAL.REF,POS>

        IF CUSTOMER.TYPE EQ "PERSONA FISICA" THEN
            COMI = "N"
        END ELSE
            COMI = "J"
        END

        RETURN

    END ELSE

        CALL F.READ.HISTORY(FN.ACC,ID,R.HIS,F.ACC,ERRH)
        CUSTOMER.ID = R.HIS<AC.CUSTOMER>

        CALL F.READ(FN.CUS,CUSTOMER.ID,R.CUS,F.CUS,ERRCUS)
        CALL GET.LOC.REF("CUSTOMER","L.CU.TIPO.CL",POS)
        CUSTOMER.TYPE = R.CUS<EB.CUS.LOCAL.REF,POS>

        IF CUSTOMER.TYPE EQ "PERSONA FISICA" THEN
            COMI = "N"
        END ELSE
            COMI = "J"
        END

        RETURN

    END

END
