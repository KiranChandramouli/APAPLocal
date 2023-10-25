$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------
* <Rating>0</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE ITSS.IBSOLUTION.ARCIB.MIG.LOAD
*---------------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                    REFERENCE                     DESCRIPTION
*25/10/2023         Suresh             R22 Manual Conversion                 Nochange
*----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT  I_IBSOLUTION.ARCIB.MIG.COMMON
    $INSERT I_BATCH.FILES

    FN.EB.EXTERNAL.USER = "F.EB.EXTERNAL.USER"
    F.EB.EXTERNAL.USER = ""

    FN.CUSTOMER = "F.CUSTOMER"
    F.CUSTOMER = ""

    FN.AA.ARRANGEMENT = "F.AA.ARRANGEMENT"
    F.AA.ARRANGEMENT = ""

    CALL OPF(FN.EB.EXTERNAL.USER,F.EB.EXTERNAL.USER)
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.USER.OUT = 'IB_USER.csv_' : SESSION.NO
    FN.PHONE.OUT = 'IB_PHONE.csv_' : SESSION.NO
    FN.LEAGAL.ID.OUT = 'IB_LEAGAL_ID.csv_' : SESSION.NO
    FN.COMPANY.OUT = 'IB_COMPANY.csv_' : SESSION.NO
    FN.EMAIL.OUT= 'IB_EMAIL.csv_' : SESSION.NO

    FILE.USER.OUT = ""
    FILE.PHONE.OUT = ""
    FILE.LEAGAL.ID.OUT =""
    FILE.COMPANY.OUT =""
    FILE.EMAIL.OUT = ""

    LIST.ALL.COMPANY = ""

    OPENSEQ FN.USER.OUT  TO FILE.USER.OUT ELSE
        CREATE FN.USER.OUT THEN
        END
    END

    OPENSEQ FN.PHONE.OUT  TO FILE.PHONE.OUT ELSE
        CREATE FN.PHONE.OUT THEN
        END
    END


    OPENSEQ FN.LEAGAL.ID.OUT  TO FILE.LEAGAL.ID.OUT ELSE
        CREATE FN.LEAGAL.ID.OUT THEN
        END
    END

    OPENSEQ FN.COMPANY.OUT  TO FILE.COMPANY.OUT ELSE
        CREATE FN.COMPANY.OUT THEN
        END
    END

    OPENSEQ FN.EMAIL.OUT  TO FILE.EMAIL.OUT ELSE
        CREATE FN.EMAIL.OUT THEN
        END
    END


    FN.IB.USER.ERR.OUT = 'IB_USER_ERROR.xml_' : SESSION.NO
    FILE.ERR.OUT = ""
    OPENSEQ FN.IB.USER.ERR.OUT  TO FILE.ERR.OUT ELSE
        CREATE FN.IB.USER.ERR.OUT THEN
        END
    END



RETURN
